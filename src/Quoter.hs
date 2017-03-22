{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts, DeriveLift #-}

module Quoter where

import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax
import Text.Regex.Posix
import Data.List.Split
import Text.Regex
import Data.List

mkDate :: Int -> Int -> Int -> Date
mkDate d m y
  | d > 31 || d < 0 = error "incorrect Day"
  | m > 12 || m < 1 = error "incorrect Month"
  | y < 0           = error "incorrect Year"
  | otherwise = Date d m y


data Result = Pass | Fail deriving (Show, Lift)

data Date = Date Int Int Int deriving Lift
instance Show Date where
  show (Date d m y) = show d ++ "." ++ show m ++ "." ++ show y



data TestCase = TestCase{
      desc :: String,
      proc :: [String],
      outp :: String,
      date :: Date,
      result :: Result,
      note :: Maybe String
    }
  deriving Lift

instance Show TestCase where
  show (TestCase desc proc outp date res note) =
    "DESC\n"
    ++ "\t" ++ desc ++ "\n"
    ++ "PROC\n"
    ++ concatMap (\p -> "\t" ++ p ++ "\n") proc
    ++ "OUTP\n"
    ++ "\t" ++ outp ++ "\n"
    ++ "DATE\n"
    ++ "\t" ++ show date ++ "\n"
    ++ "NOTE\n"
    ++ "\t" ++ showNote note ++ "\n"
    where showNote (Just n) = n
          showNote Nothing = ""

showMD :: Int -> TestCase -> String
showMD i (TestCase desc proc outp date res note) =
  "|" ++ "TC" ++ show i
  ++ "|" ++ br desc
  ++ "|<ol>" ++ concatMap (\p -> "<li>" ++ br p ++ "</li>") proc ++ "</ol>"
  ++ "|" ++ br outp
  ++ "|" ++ show res
  ++ "|" ++ show date
  ++ "|" ++ showNote note
  ++ "|"
  where showNote (Just n) = br n
        showNote Nothing = ""
        br = insertEvery 20 "<br/>"

makeMD :: [TestCase] -> String
makeMD = (pref ++) . concat . map (++"\n") . zipWith showMD [1..]
  where pref =  "| Id | Description | Steps | Output | Result | Date | Notes |\n"
              ++"|----|-------------|-------|--------|--------|------|-------|\n"

insertEvery :: Int -> [a] -> [a] -> [a]
insertEvery n ys xs = countdown n xs where
   countdown 0 xs = ys ++ countdown n xs
   countdown _ [] = []
   countdown m (x:xs) = x:countdown (m-1) xs

qq1 :: QuasiQuoter
qq1 = QuasiQuoter {
          quoteExp = quoteExp1,
          quotePat = undefined,
          quoteType = undefined,
          quoteDec = undefined
       }

quoteExp0 = stringE
quoteExp1 = lift . map parseTestCase . drop 1 . deepDelimBy "TESTCASE"

parseTestCase s = TestCase{
  desc = clear $ enclosedBy "DESC" "PROC" s,
  proc = delimBy "|>" $ clear $ enclosedBy "PROC" "OUTP" s,
  outp = clear $ enclosedBy "OUTP" "DATE" s,
  date = catchDate $ enclosedBy "DATE" "NOTE" s,
  result = checkRes $ enclosedBy "DATE" "NOTE" s,
  note = Nothing
  }
  where checkRes s =  if      "PASS" `isInfixOf` s then Pass
                      else if "FAIL" `isInfixOf` s then Fail
                      else    Fail
        clear = filter (\c -> c /= '\n' && c /= '\t')
        catchDate s = case matchRegex (mkRegex "([0-9]{2}.[0-9]{2}.[0-9]{4})") s of
          Just (m:ms) -> mkDate dd mm yyyy where
            dd =    read $ take 2 m
            mm =    read $ take 2 $ drop 3 m
            yyyy =  read $ drop 6 m
          _ -> Date 1 2 1

delimBy :: String -> String -> [String]
delimBy d = splitRegex $ mkRegex ("["++d++"]+")

deepDelimBy :: String -> String -> [String]
deepDelimBy d = splitRegex $ mkRegex d

enclosedBy :: String -> String -> String -> String
enclosedBy a b s = match
  where match :: String
        match = case matchRegex (mkRegex $ a++"((.*?\n?)*)"++b) s of
          Just (m:ms) -> m
          _ -> ""
        dropped = drop $ length a
        tail' ss = take (length ss - length b) ss
