module ShogiBoard.Board
  ( Board
  , fromList
  , toList
  , check
  , pieces
  , move
  , drop
  , ShogiBoard.Board.moves
  , ShogiBoard.Board.drops
  , lookup
  ) where

import Prelude hiding (drop, lookup)
import Data.Maybe (maybe, maybeToList)
import qualified Data.Map as Map
import Control.Monad (guard)
import ShogiBoard.Square
import ShogiBoard.Piece as Piece
import Shogi.Color

-- | 将棋盤
newtype Board = Board { getBoard :: (Map.Map Square Piece) } deriving (Eq, Show)

-- | 升目と駒のリストから将棋盤作成
fromList :: [(Square, Piece)] -> Board
fromList = Board . Map.fromList

-- | 将棋盤の升目と駒のリスト
toList :: Board -> [(Square, Piece)]
toList (Board board) = Map.toList board

-- | 王手判定
check :: Color -> Board -> Bool
check color board = maybe False (flip elem moves') $ kingSquare color board
  where
    moves' = do
      (from, _) <- pieces turnedColor board
      (to,   _) <- ShogiBoard.Board.moves (from, turnedColor) board
      return to
    turnedColor = turn color

-- | 王の升目
kingSquare :: Color -> Board -> Maybe Square
kingSquare color board = if null kings then Nothing else Just $ fst $ head kings
  where
    kings = filter (\(_, piece) -> piece == king color) $ pieces color board

-- | 手番の駒リスト
pieces :: Color -> Board -> [(Square, Piece)]
pieces color = filter (\(_, piece) -> color == getColor piece) . toList

-- | 駒を動かす
move :: MoveFrom -> MoveTo -> Board -> Maybe Board
move from@(from', color) moveTo@(to, promoted) board = do
  piece <- lookup from' board
  guard $ getColor piece == color
  guard $ elem moveTo $ ShogiBoard.Board.moves from board
  let deletedBoard = Map.delete from' (getBoard board)
  return board { getBoard = Map.insert to piece { getPromoted = promoted } deletedBoard }

-- | 持ち駒を指す
drop :: Piece -> Square -> Board -> Maybe Board
drop piece square board = if drops' then Just drop' else Nothing
  where
    drops' = elem square $ ShogiBoard.Board.drops piece board
    drop'  = board { getBoard = Map.insert square piece $ getBoard board }

-- | 駒を動かせる升目リスト
moves :: MoveFrom -> Board -> [MoveTo]
moves from@(from', color) board = do
  piece <- maybeToList $ lookup from' board
  guard $ getColor piece == color
  squares <- Piece.moves piece from'
  moves' squares piece board
  where
    moves' [] _ _ = []
    moves' (square:squares) piece board = do
      case lookup square board of
        (Just piece') -> if getColor piece' == getColor piece
                         then []
                         else moveTo'
        Nothing       -> moveTo' ++ moves' squares piece board
      where
        moveTo' = [(square, promotion) | promotion <- promotions piece square]

-- | 持ち駒を指せる升目リスト
drops :: Piece -> Board -> [Square]
drops piece board
  | getType piece == Pawn = filterPawnFiles squares
  | otherwise             = squares
  where
    filterPawnFiles = filter (\(file, _) -> not $ elem file pawnFiles)
    pawnFiles       = map (fst . fst) $ filter (\(_, piece) -> getType piece == Pawn && getPromoted piece == False) $ pieces (getColor piece) board
    squares         = filter (\square -> (lookup square board) == Nothing) $ Piece.drops piece

-- | 升目の駒
lookup :: Square -> Board -> Maybe Piece
lookup square (Board board) = Map.lookup square board
