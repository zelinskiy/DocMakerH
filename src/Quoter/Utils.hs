module Quoter.Utils where


insertEvery :: Int -> [a] -> [a] -> [a]
insertEvery n ys xs = countdown n xs where
  countdown 0 xs = ys ++ countdown n xs
  countdown _ [] = []
  countdown m (x:xs) = x:countdown (m-1) xs
