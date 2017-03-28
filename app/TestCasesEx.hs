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

TESTCASE
DESC
   Проект собирается на "чистой" машине
PROC
  Студия запущена, ветка master скачена
  |> Нажать F6
OUTP
  Студия ответила
  ========== Build: 1 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========
DATE
  28.03.2017
PASS
NOTE
  -//-

TESTCASE
DESC
   Проект подымается
PROC
  #TC1
  |> Нажать F5
OUTP
  Открывается эдж с адресом http://localhost:3979/
DATE
  28.03.2017
PASS
NOTE
  -//-

TESTCASE
DESC
   эмулятор конектится
PROC
  #ТС2, Бот эмулятор запущен
  |> Внести в поле вверху http://localhost:3979/api/messages
  |> set AppId := $APPID
  |> set Password = $PASS
  |> click Connect
OUTP
  Emulator log ends with POST 200 [conversationUpdate]
DATE
  28.03.2017
PASS
NOTE
  -//-

TESTCASE
DESC
   Бот приветствует
PROC
  #TC3
  |> сказать Hello боту
OUTP
  бот ответил Hello, how can i help you today?
DATE
  28.03.2017
PASS
NOTE
  -//-

TESTCASE
DESC
   Бот обьясняет себя
PROC
  #TC4
  |> сказать~ Help боту
OUTP
  бот рассказывает что можно делать
DATE
  28.03.2017
FAIL
NOTE
  -//-



|]
