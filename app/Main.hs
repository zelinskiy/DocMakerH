{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts #-}

import Language.Haskell.TH
import Quoter

ex1 :: Q Exp
ex1 = [| \x -> x |]


ex4 = [qq1|
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
  looooooooooooooooooooooooooooooooooooooooooooooooooooooong
DATE
  25.05.2016
FAIL
NOTE
  Some note
|]


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


main = do
  writeFile "cases.md" $ makeMD ex4
