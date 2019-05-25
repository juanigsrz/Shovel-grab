-- Extend tuples syntax
{-# LANGUAGE TupleSections #-}

module Parsing (parser) where

import Control.Applicative (empty)
import Control.Monad (void)
import Data.Void
import Data.Char (isAlphaNum)
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

-- TODO
type Parser      = Parsec Void String
type ComplexItem = (String, [String])
type ItemList    = (String, [ComplexItem])

-- We allow one-line comments starting with '#'
lineComment :: Parser ()
lineComment = L.skipLineComment "#"

-- Space-consumer with endlines
scn :: Parser ()
scn = L.space space1 lineComment empty

-- Space-consumer without endlines
sc :: Parser ()
sc = L.space (void $ takeWhile1P Nothing f) lineComment empty
        where f x = x == ' ' || x == '\t'

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

pItem :: Parser String
pItem = lexeme (takeWhile1P Nothing f) <?> "list item"
           where f x = isAlphaNum x || x == '-'

pComplexItem :: Parser ComplexItem
pComplexItem = L.indentBlock scn p
                  where p = do header <- pItem
                               return $ L.IndentMany Nothing (return . (header, )) pLineFold

pLineFold :: Parser String
pLineFold = L.lineFold scn $ \sc' ->
               let ps  = takeWhile1P Nothing f `sepBy1` try sc'
                   f x = isAlphaNum x || x == '-'
               in unwords <$> ps <* sc

pItemList :: Parser ItemList
pItemList = L.nonIndented scn (L.indentBlock scn p)
               where p = do header <- pItem
                            return $ L.IndentSome Nothing (return . (header, )) pComplexItem

pItemListList :: Parser [ItemList]
pItemListList = do many pItemList

parser :: Parser [ItemList]
parser = pItemListList <* eof
