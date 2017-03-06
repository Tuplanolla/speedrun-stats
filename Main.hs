{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveFoldable, DeriveFunctor, DeriveTraversable #-}

module Main where

import Control.Monad
import Data.Maybe
import qualified Data.Text.IO as Text
import Data.Time.Clock
import Data.Time.Format
import System.Environment
import System.Exit
import System.IO
import Text.XML.Light

data Pair a b = !a :* !b
  deriving (Foldable, Functor, Eq, Ord, Read, Show, Traversable)
infix 1 :*

forMaybe :: [a] -> (a -> Maybe b) -> [b]
forMaybe = flip mapMaybe

name :: String -> QName
name str = blank_name {qName = str}

data Fate = Reset | Finished
  deriving (Eq, Ord, Read, Show)

data Run = Run
  {fate :: !Fate,
   date :: !(Pair UTCTime NominalDiffTime),
   time :: !(Pair NominalDiffTime NominalDiffTime)}
  deriving (Eq, Ord, Show)

readId :: String -> Int
readId !xs = read xs

parseDateTime :: String -> Maybe UTCTime
parseDateTime !str = parseTimeM False defaultTimeLocale "%m/%d/%Y %H:%M:%S" str

parseRealTime :: String -> Maybe NominalDiffTime
parseRealTime !str = diffUTCTime <$>
  parseTimeM False defaultTimeLocale "%H:%M:%S%Q" str <*>
  parseTimeM False defaultTimeLocale "%s" "0"

getRuns :: Element -> Maybe [Run]
getRuns run = do
  history <- findChild (name "AttemptHistory") run
  let attempts = findChildren (name "Attempt") history
  pure $ attempts `forMaybe` \ attempt -> do
    start <- parseDateTime =<< findAttr (name "started") attempt
    case parseRealTime . strContent =<<
         findChild (name "RealTime") attempt of
      Nothing -> do
        end <- parseDateTime =<< findAttr (name "ended") attempt
        pure Run
          {fate = Reset,
           date = start :* realToFrac (1 :: Double),
           time = diffUTCTime end start :* realToFrac (sqrt 2 :: Double)}
      Just realTime -> pure Run
        {fate = Finished,
         date = start :* realToFrac (1 :: Double),
         time = realTime :* realToFrac (0.1 :: Double)}

formatNominalDiffTime :: NominalDiffTime -> String
formatNominalDiffTime !time = show (realToFrac time :: Double)

formatRow :: Pair UTCTime NominalDiffTime ->
  Pair NominalDiffTime NominalDiffTime -> String
formatRow !(date :* dateError) !(time :* timeError) =
  formatTime defaultTimeLocale "%s%Q" date ++ " " ++
  formatNominalDiffTime time ++ " " ++
  formatNominalDiffTime dateError ++ " " ++
  formatNominalDiffTime timeError

main :: IO ()
main = do
  filePaths <- getArgs
  filePaths `forM_` \ filePath -> do
    file <- Text.readFile filePath
    case getRuns =<< parseXMLDoc file of
      Just runs -> do
        runs `forM_` \ run ->
          case run of
            Run {fate = Reset, date = date, time = time} ->
              hPutStrLn stdout (formatRow date time)
            Run {fate = Finished, date = date, time = time} ->
              hPutStrLn stderr (formatRow date time)
        exitSuccess
      Nothing -> exitFailure
