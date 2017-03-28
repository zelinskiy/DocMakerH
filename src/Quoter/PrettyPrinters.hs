module Quoter.PrettyPrinters where

import Quoter.Utils
import Quoter.Types

showMD :: Int -> TestCase -> MDoutput
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

showMDtable :: [TestCase] -> MDoutput
showMDtable = (pref ++) . concat . map (++"\n") . zipWith showMD [1..]
  where pref =  "| Id | Description | Steps | Output | Result | Date | Notes |\n"
              ++"|----|-------------|-------|--------|--------|------|-------|\n"


showHTML :: Int -> TestCase -> MDoutput
showHTML i (TestCase desc proc outp date res note) =
  "<tr><td>" ++ "TC" ++ show i ++ "</td>"
  ++ "<td>" ++ br desc ++ "</td>"
  ++ "<td><ol start=\"0\">" ++ concatMap (\p -> "<li>" ++ br p ++ "</li>") proc ++ "</ol></td>"
  ++ "<td>" ++ br outp ++ "</td>"
  ++ "<td>" ++ show res ++ "</td>"
  ++ "<td>" ++ show date ++ "</td>"
  ++ "<td>" ++ showNote note ++ "</td>"
  ++ "</tr>"
  where showNote (Just n) = br n
        showNote Nothing = ""
        br = insertEvery 20 "<br/>"

showHTMLtable :: [TestCase] -> MDoutput
showHTMLtable = (\r -> pref ++ r ++ postf) . concat . zipWith showHTML [1..]
  where pref =  "<table border=\"1\"><tr>"
              ++"<td>Id</td>"
              ++"<td>Description</td>"
              ++"<td>Steps</td>"
              ++"<td>Output</td>"
              ++"<td>Result</td>"
              ++"<td>Date</td>"
              ++"<td>Notes</td></tr>"
        postf = "</table>"
