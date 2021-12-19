------------------------------------------------------------------
-- NOTE: this is not my code, see the comment in the other file --
------------------------------------------------------------------

---- CORE LOGIC

data SnailFish = EndSingle Integer | SnailPair SnailFish SnailFish deriving Eq

explode :: Integer -> (Integer -> Integer -> SnailFish -> SnailFish) -> SnailFish -> Maybe SnailFish
explode x recons (SnailPair (EndSingle a) (EndSingle b)) | x > 3 = Just (recons a b (EndSingle 0))
explode x recons (SnailPair v1 v2)
  | Just v1M <- explode (x + 1) (\a b v -> recons a 0 (SnailPair v (plusFirst b v2))) v1 = Just v1M
  | Just v2M <- explode (x + 1) (\a b v -> recons 0 b (SnailPair (plusLast a v1) v)) v2 = Just v2M
  | otherwise = Nothing
    where
      plusFirst x (EndSingle y) = EndSingle $ x + y
      plusFirst x (SnailPair y z) = SnailPair (plusFirst x y) z
      plusLast x (EndSingle y) = EndSingle $ x + y
      plusLast x (SnailPair y z) = SnailPair y (plusLast x z)
explode _ _ _ = Nothing

split :: SnailFish -> Maybe SnailFish
split (EndSingle x) | x >= 10 = Just (SnailPair (EndSingle (x `div` 2)) (EndSingle (x `div` 2 + x `mod` 2)))
split (SnailPair v1 v2)
  | Just v1M <- split v1 = Just $ SnailPair v1M v2
  | Just v2M <- split v2 = Just $ SnailPair v1 v2M
  | otherwise = Nothing
split _ = Nothing

reduceProcess :: SnailFish -> Maybe SnailFish
reduceProcess s = explode 0 (\a b c -> c) s <|> split s

reduceFully :: SnailFish -> SnailFish
reduceFully = fromMaybe <*> join . listToMaybe . reverse . takeWhile isJust . iterate (reduceProcess =<<) . pure
-- chef's kiss

addSnailFish :: SnailFish -> SnailFish -> SnailFish
addSnailFish = fmap reduceFully . SnailPair

snailMagnitude :: SnailFish -> Integer
snailMagnitude (EndSingle x) = x
snailMagnitude (SnailPair x y) = 3 * snailMagnitude x + 2 * snailMagnitude y

---- PARTS 1 AND 2

snailFishParser :: Parser SnailFish
snailFishParser
  =   (EndSingle <$> L.decimal)
  <|> (SnailPair <$> (char '[' *> snailFishParser) <*> (char ',' *> snailFishParser <* char ']'))

-- >>> lines <- input
-- >>> snailMagnitude . foldl1 addSnailFish $ lines
-- >>> pure . snailMagnitude . foldl1 addSnailFish $ lines
-- >>> maximum . fmap (snailMagnitude . uncurry addSnailFish) $ validPairs
