import Test.Tasty

import ShogiTest

import ShogiBoardTest.BoardTest     as BoardTest
import ShogiBoardTest.ListsTest     as ListsTest
import ShogiBoardTest.CheckTest     as CheckTest
import ShogiBoardTest.CheckmateTest as CheckmateTest
import ShogiBoardTest.MoveTest      as MoveTest
import ShogiBoardTest.DropTest      as DropTest
import ShogiBoardTest.MovesTest     as MovesTest
import ShogiBoardTest.DropsTest     as DropsTest

main :: IO ()
main = defaultMain $ testGroup "ShogiBoard"
  [ ShogiTest.tests
  , BoardTest.tests
  , ListsTest.tests
  , CheckTest.tests
  , CheckmateTest.tests
  , MoveTest.tests
  , DropTest.tests
  , MovesTest.tests
  , DropsTest.tests
  ]
