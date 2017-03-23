{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts #-}

import Quoter.PrettyPrinters
import TestCasesEx(example)

main :: IO ()
main = writeFile "cases.html" $ showHTMLtable example


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
