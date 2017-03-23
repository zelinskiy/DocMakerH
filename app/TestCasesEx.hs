{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts #-}
module TestCasesEx where

import Quoter.Types(TestCase)
import Quoter(testcases)

example :: [TestCase]
example = [testcases|
TESTCASE
DESC
  Registration
PROC
  Open site,
  which is site http |>
  Enter smth |>
  Close site
OUTP
  Account created
  looooooooooooooooooooooooooooooooooooooooooooooooooooooong
DATE
  19.11.2016
PASS
NOTE
  Some note

|]
