module ShogiTest.BoardTest.MoveTest (tests) where

import           Shogi.Board
import           Shogi.Color
import           Shogi.Piece
import           Shogi.Square
import           Test.Tasty
import           Test.Tasty.HUnit

tests :: TestTree
tests = testGroup "move"
    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                 歩             R9
    --}
  [ testCase "先手歩兵" $ move ((F5, R9), Black) ((F5, R8), False) (fromList [((F5, R9), pawn False Black)]) @?= Just (fromList [((F5, R8), pawn False Black)])
    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                 と             R9
    --}
  , testCase "先手と金" $ move ((F5, R9), Black) ((F5, R8), False) (fromList [((F5, R9), pawn True Black)]) @?= Just (fromList [((F5, R8), pawn True Black)])
    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                V歩             R1
    --}
  , testCase "後手歩兵" $ move ((F5, R1), White) ((F5, R2), False) (fromList [((F5, R1), pawn False White)]) @?= Just (fromList [((F5, R2), pawn False White)])
    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                Vと             R1
    --}
  , testCase "後手と金" $ move ((F5, R1), White) ((F5, R2), False) (fromList [((F5, R1), pawn True White)]) @?= Just (fromList [((F5, R2), pawn True White)])
    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                 金             R8
                 歩             R9
    --}
  , testCase "先手歩兵動けない" $ move ((F5, R9), Black) ((F5, R8), False) (fromList [((F5, R9), pawn False Black), ((F5, R8), gold Black)]) @?= Nothing

    {--
     F9 F8 F7 F6 F5 F4 F3 F2 F1
                V金             R8
                 歩             R9
    --}
  , testCase "先手歩兵駒を取る" $ move ((F5, R9), Black) ((F5, R8), False) (fromList [((F5, R9), pawn False Black), ((F5, R8), gold White)]) @?= Just (fromList [((F5, R8), pawn False Black)])
  ]
