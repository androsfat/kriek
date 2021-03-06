{-# language MultiParamTypeClasses #-}
module Kriek.Runtime.Data where

import Control.Monad.Reader
import Control.Monad.State.Strict hiding (State)
import Control.Monad.Except
import qualified Data.HashMap.Strict as M
import Kriek.Ast

type Fn = [Form] -> Runtime (Form)

data Scope = Scope { scopeRec :: [Form], scopeNonrec :: [Form]}

type Runtime r = ReaderT Scope (StateT State IO) r

type Map = M.HashMap Name AST

data RT = RTFn Fn

instance Show RT where
  show (RTFn _) = "function"

instance Eq RT where
  _ == _ = False

data IName = IName Name
           | IRename { rFrom :: Name, rTo ::  Name }

data Import = Import
  { iModule :: IName
  , iImports :: [IName] }

data State = State
  { stateImports :: [(Name, Name)]
  , stateVals :: Map
  , stateMacros :: M.HashMap Name Fn }

newState :: State
newState = State [] M.empty M.empty
