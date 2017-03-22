{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts #-}

import Quoter
import Quoter.PrettyPrinters
import Quoter.Types

ex4 :: [TestCase]
ex4 = [testcases|
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
DATE
  25.05.2016
FAIL
NOTE
  Some note
|]
{-
rawExamples :: [TestCase]
rawExamples = [
  TestCase
      "Registration"
      [
        "Open site",
        "Close site"
      ]
      "Site opend and closed"
      (mkDate 19 11 2016)
      Pass
      Nothing
  ,
  TestCase
      "Registration"
      [
        "Open site",
        "Close site"
      ]
      "Site opend and closed"
      (mkDate 19 11 2016)
      Pass
      Nothing
  ]
-}
main :: IO ()
main = writeFile "cases.md" $ showMDtable ex4
