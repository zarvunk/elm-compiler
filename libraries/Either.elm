module Either where

{-| Represents any data that can take two different types.

# Type and Constructors
@docs Either, Left, Right

# Taking Eithers apart
@docs either, isLeft, isRight

# Eithers and Lists
@docs lefts, rights, partition, consLeft, consRight, consEither

-}

import List

{-| This can also be used for error handling `(Either String a)` where
    error messages are stored on the left, and the correct values
    (&ldquo;right&rdquo; values) are stored on the right.
-}
data Either a b = Left a | Right b

{-| Apply the first function to a `Left` and the second function to a `Right`.
    This allows the extraction of a value from an `Either`.
-}
either : (a -> c) -> (b -> c) -> Either a b -> c
either f g e = case e of { Left x -> f x ; Right y -> g y }

{-| True if the value is a `Left`. -}
isLeft : Either a b -> Bool
isLeft e = case e of { Left  _ -> True ; _ -> False }

{-| True if the value is a `Right`. -}
isRight : Either a b -> Bool
isRight e = case e of { Right _ -> True ; _ -> False }

{-| Keep only the values held in `Left` values. -}
lefts : [Either a b] -> [a]
lefts es = List.foldr consLeft [] es

{-| Keep only the values held in `Right` values. -}
rights : [Either a b] -> [b]
rights es = List.foldr consRight [] es

{-| Split into two lists, lefts on the left and rights on the right. So we
    have the equivalence: `(partition es == (lefts es, rights es))`
-}
partition : [Either a b] -> ([a],[b])
partition es = List.foldr consEither ([],[]) es

{-| If `Left`, add the value to the front of the list. 
    If `Right`, return the list unchanged
-}
consLeft : Either a b -> [a] -> [a]
consLeft e vs =
    case e of
      Left  v -> v::vs
      Right _ -> vs

{-| If `Right`, add the value to the front of the list.
    If `Left`, return the list unchanged.
-}
consRight : Either a b -> [b] -> [b]
consRight e vs =
    case e of
      Left  _ -> vs
      Right v -> v::vs

{-| If `Left`, add the value to the left list.
    If `Right`, add the value to the right list.
-}
consEither : Either a b -> ([a], [b]) -> ([a], [b])
consEither e (ls,rs) =
    case e of
      Left  l -> (l::ls,rs)
      Right r -> (ls,r::rs)
