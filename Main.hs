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

forMaybe :: [a] -> (a -> Maybe b) -> [b]
forMaybe = flip mapMaybe

name :: String -> QName
name str = blank_name {qName = str}

data Uncertain a = a :+- a
  deriving (Eq, Ord, Read, Show)

data Run a =
  Reset {at :: Uncertain a} |
  Finished {at :: Uncertain a}
  deriving (Eq, Ord, Read, Show)

readId :: String -> Int
readId = read

parseDateTime :: String -> Maybe UTCTime
parseDateTime str = parseTimeM False defaultTimeLocale "%m/%d/%Y %H:%M:%S" str

parseRealTime :: String -> Maybe NominalDiffTime
parseRealTime str = diffUTCTime <$>
  parseTimeM False defaultTimeLocale "%H:%M:%S%Q" str <*>
  parseTimeM False defaultTimeLocale "%s" "0"

getRuns :: Element -> Maybe [Run NominalDiffTime]
getRuns run = do
  history <- findChild (name "AttemptHistory") run
  let attempts = findChildren (name "Attempt") history
  return $ attempts `forMaybe` \ attempt -> do
    case parseRealTime . strContent =<<
         findChild (name "RealTime") attempt of
      Nothing -> do
        start <- parseDateTime =<< findAttr (name "started") attempt
        end <- parseDateTime =<< findAttr (name "ended") attempt
        return Reset {at = diffUTCTime end start :+- realToFrac (sqrt 2 :: Double)}
      Just realTime ->
        return Finished {at = realTime :+- realToFrac (0.001 :: Double)}

main :: IO ()
main = do
  filePaths <- getArgs
  filePaths `forM_` \ filePath -> do
    file <- Text.readFile filePath
    case getRuns =<< parseXMLDoc file of
      Just runs -> do
        runs `forM_` \ run ->
          let showTime (value :+- uncertainty) =
                show (realToFrac value :: Double) ++ " " ++
                show (realToFrac uncertainty :: Double) in
            case run of
              Reset {at = time} -> hPutStrLn stdout (showTime time)
              Finished {at = time} -> hPutStrLn stderr (showTime time)
        exitSuccess
      Nothing -> exitFailure
