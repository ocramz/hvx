{-# LANGUAGE FlexibleContexts #-}

module HVX.Internal.Constraints
  ( leq
  , (<=~)
  , geq
  , (>=~)
  , Constraint
  ) where

import HVX.Primitives
import HVX.Internal.Primitives
import HVX.Internal.DCP

type Constraint = Expr Convex Nonmon

class CanConstrain v
instance CanConstrain Convex
instance CanConstrain Affine

-- | lhs <= rhs
-- becomes
-- max(lhs - rhs) <= 0
leq :: (Vex vl, Vex vr, Mon ml, Mon mr,
        Mon (ApplyMon Noninc mr),
        Mon (AddMon ml (ApplyMon Noninc mr)),
        Vex (ApplyVex Affine Noninc vr mr),
        Vex (AddVex vl (ApplyVex Affine Noninc vr mr))) =>
       Expr vl ml -> Expr vr mr -> Constraint
leq lhs rhs = EFun Max (lhs +~ neg rhs)

infix 4 <=~
(<=~) :: (Vex vl, Vex vr, Mon ml, Mon mr,
          Mon (ApplyMon Noninc mr),
          Mon (AddMon ml (ApplyMon Noninc mr)),
          Vex (ApplyVex Affine Noninc vr mr),
          Vex (AddVex vl (ApplyVex Affine Noninc vr mr))) =>
         Expr vl ml -> Expr vr mr -> Constraint
(<=~) = leq

-- | lhs >= rhs
-- becomes
-- max(rhs - lhs) <= 0
geq :: (Vex vl, Vex vr, Mon ml, Mon mr,
        Mon (ApplyMon Noninc ml),
        Mon (AddMon mr (ApplyMon Noninc ml)),
        Vex (ApplyVex Affine Noninc vl ml),
        Vex (AddVex vr (ApplyVex Affine Noninc vl ml))) =>
       Expr vl ml -> Expr vr mr -> Constraint
geq lhs rhs = EFun Max (rhs +~ neg lhs)

infix 4 >=~
(>=~) :: (Vex vl, Vex vr, Mon ml, Mon mr,
          Mon (ApplyMon Noninc ml),
          Mon (AddMon mr (ApplyMon Noninc ml)),
          Vex (ApplyVex Affine Noninc vl ml),
          Vex (AddVex vr (ApplyVex Affine Noninc vl ml))) =>
         Expr vl ml -> Expr vr mr -> Constraint
(>=~) = geq
