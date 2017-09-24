module ShogiBoardTest.BoardTest.DropTest (tests) where

import Test.Tasty
import Test.Tasty.HUnit
import Prelude hiding (drop)
import ShogiBoard.Board
import ShogiBoard.Piece
import ShogiBoard.Square
import Shogi.Color

tests :: TestTree
tests = testGroup "drop"
  [ testCase "先手歩兵" $ drop (pawn False Black) (F5, R5) (fromList []) @?= Just (fromList [((F5, R5), pawn False Black)])
  , testCase "後手歩兵" $ drop (pawn False White) (F5, R5) (fromList []) @?= Just (fromList [((F5, R5), pawn False White)])

  , testCase "先手歩兵指せない" $ drop (pawn False Black) (F5, R5) (fromList [((F5, R5), gold White)]) @?= Nothing
  , testCase "後手歩兵指せない" $ drop (pawn False White) (F5, R5) (fromList [((F5, R5), gold Black)]) @?= Nothing

  , testCase "先手歩兵二歩" $ drop (pawn False Black) (F5, R5) (fromList [((F5, R9), pawn False Black)]) @?= Nothing
  , testCase "後手歩兵二歩" $ drop (pawn False White) (F5, R5) (fromList [((F5, R1), pawn False White)]) @?= Nothing

  , testCase "先手歩兵二歩でない(相手の歩)" $ drop (pawn False Black) (F5, R5) (fromList [((F5, R9), pawn False White)]) @?= Just (fromList [((F5, R5), pawn False Black), ((F5, R9), pawn False White)])
  , testCase "後手歩兵二歩でない(相手の歩)" $ drop (pawn False White) (F5, R5) (fromList [((F5, R1), pawn False Black)]) @?= Just (fromList [((F5, R1), pawn False Black), ((F5, R5), pawn False White)])

  , testCase "先手歩兵二歩でない(と金)" $ drop (pawn False Black) (F5, R5) (fromList [((F5, R9), pawn True Black)]) @?= Just (fromList [((F5, R5), pawn False Black), ((F5, R9), pawn True Black)])
  , testCase "後手歩兵二歩でない(と金)" $ drop (pawn False White) (F5, R5) (fromList [((F5, R1), pawn True White)]) @?= Just (fromList [((F5, R1), pawn True White), ((F5, R5), pawn False White)])
  ]
