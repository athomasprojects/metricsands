(*
   Quantities are expressed through a `coherent system of units` in which every quantity has unique unit, or that does not use conversion factors.
*)
open Core
module StrTable = Hashtbl.Make (String)
module StrMap = Map.Make (String)

type base_unit =
  | Gram
  | Metre
  | Second
  | Joule
  | Kelvin
  | Mol
  | Candela

type si_unit =
  | Volt
  | Ampere
  | Ohm
  | Coulomb
  | Farad
  | Hertz
  | Newton
  | ElectronVolt
  | Radian
  | Degree
  | Steradian
  | Pascal
  | Watt
  | Siemens
  | Henry
  | Weber
  | Tesla
  | Lumen
  | Celsius
  | Lux
  | Becquerel
  | Gray
  | Sievert
  | Katal

let base_units = [ "m"; "g"; "s"; "sec"; "K"; "mol"; "cd" ]

let si_units =
  [ "V"
  ; "A"
  ; "Ohm"
  ; "C"
  ; "F"
  ; "Hz"
  ; "N"
  ; "eV"
  ; "rad"
  ; "deg"
  ; "sr"
  ; "Pa"
  ; "W"
  ; "S"
  ; "H"
  ; "Wb"
  ; "T"
  ; "Celsius"
  ; "lm"
  ; "lx"
  ; "Bq"
  ; "Gy"
  ; "Sv"
  ; "kat"
  ]
;;

type prefix =
  | NoPrefix
  | Quecto
  | Ronto
  | Yocto
  | Zepto
  | Atto
  | Femto
  | Pico
  | Nano
  | Micro
  | Milli
  | Centi
  | Deci
  | Deca
  | Hecto
  | Kilo
  | Mega
  | Giga
  | Tera
  | Peta
  | Exa
  | Zetta
  | Yotta
  | Ronna
  | Quetta

let string_of_prefix = function
  | NoPrefix -> ""
  | Quecto -> "q"
  | Ronto -> "r"
  | Yocto -> "y"
  | Zepto -> "z"
  | Atto -> "a"
  | Femto -> "f"
  | Pico -> "p"
  | Nano -> "n"
  | Micro -> "u"
  | Milli -> "m"
  | Centi -> "c"
  | Deci -> "d"
  | Deca -> "da"
  | Hecto -> "h"
  | Kilo -> "k"
  | Mega -> "M"
  | Giga -> "G"
  | Tera -> "T"
  | Peta -> "P"
  | Exa -> "E"
  | Zetta -> "Z"
  | Yotta -> "Y"
  | Ronna -> "R"
  | Quetta -> "Q"
;;

let prefix_alist =
  [ "", NoPrefix
  ; "q", Quecto
  ; "r", Ronto
  ; "y", Yocto
  ; "z", Zepto
  ; "a", Atto
  ; "f", Femto
  ; "p", Pico
  ; "n", Nano
  ; "u", Micro
  ; "m", Milli
  ; "c", Centi
  ; "d", Deci
  ; "da", Deca
  ; "h", Hecto
  ; "k", Kilo
  ; "M", Mega
  ; "G", Giga
  ; "T", Tera
  ; "P", Peta
  ; "E", Exa
  ; "Z", Zetta
  ; "Y", Yotta
  ; "R", Ronna
  ; "Q", Quetta
  ]
;;

let value_of_prefix = function
  | NoPrefix -> 1.0
  | Quecto -> 1.e-30
  | Ronto -> 1.e-27
  | Yocto -> 1.e-24
  | Zepto -> 1.e-21
  | Atto -> 1.e-18
  | Femto -> 1.e-15
  | Pico -> 1.e-12
  | Nano -> 1.e-9
  | Micro -> 1.e-6
  | Milli -> 1.e-3
  | Centi -> 1.e-2
  | Deci -> 1.e-1
  | Deca -> 10.
  | Hecto -> 100.
  | Kilo -> 1.e3
  | Mega -> 1.e6
  | Giga -> 1.e9
  | Tera -> 1.e12
  | Peta -> 1.e15
  | Exa -> 1.e18
  | Zetta -> 1.e21
  | Yotta -> 1.e24
  | Ronna -> 1.e27
  | Quetta -> 1.e30
;;

let exponent_of_prefix = function
  | NoPrefix -> 1
  | Quecto -> -30
  | Ronto -> -27
  | Yocto -> -24
  | Zepto -> -21
  | Atto -> -18
  | Femto -> -15
  | Pico -> -12
  | Nano -> -9
  | Micro -> -6
  | Milli -> -3
  | Centi -> -2
  | Deci -> -1
  | Deca -> 1
  | Hecto -> 2
  | Kilo -> 3
  | Mega -> 6
  | Giga -> 9
  | Tera -> 12
  | Peta -> 15
  | Exa -> 18
  | Zetta -> 21
  | Yotta -> 24
  | Ronna -> 27
  | Quetta -> 30
;;

let string_prefix_table = StrTable.of_alist_exn prefix_alist
let prefix_of_string s = Hashtbl.find string_prefix_table s
