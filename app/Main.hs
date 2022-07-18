{-# LANGUAGE ForeignFunctionInterface #-}

-- This program compiles to a binary that print "Hello, Haskell!" on standard
-- output!
--
-- It is written as a demo purpose how showing how to use Foreign Function
-- Interface (FFI) in Haskell.
--
-- Real-World Haskell has a chapter focus on the FFI bindings:
-- http://book.realworldhaskell.org/read/interfacing-with-c-the-ffi.html

import Foreign.C.String (CString, newCString)

-- Haskell `UTF8 string` representation are incompatible to Rust one (at least
-- we have no compiler guarantee on it). We rather choose to rely on `CString`
-- common representation.

foreign import ccall unsafe "c_hello" hello :: CString -> IO ()

main :: IO ()
main = do
  str <- newCString "Haskell"
  hello str
