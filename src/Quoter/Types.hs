{-# LANGUAGE DeriveLift #-}

module Quoter.Types where

import Language.Haskell.TH.Syntax


type MDoutput = String
data Result = Pass | Fail deriving (Show, Lift)

data Date = Date Int Int Int deriving Lift
mkDate :: Int -> Int -> Int -> Date
mkDate d m y
  | d > 31 || d < 0 = error "incorrect Day"
  | m > 12 || m < 1 = error "incorrect Month"
  | y < 0           = error "incorrect Year"
  | otherwise = Date d m y
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
