(*
   Quantities are expressed through a `coherent system of units` in which every quantity has unique unit, or that does not use conversion factors.
*)
open Core
module StrTable = Hashtbl.Make (String)
module StrMap = Map.Make (String)

type dimension =
  | Length
  | Mass
  | Time
  | Electric_current
  | Temperature
  | Amount_of_substance
  | Luminous_intensity
  | Dimensionless

type dim =
  { length : int
  ; mass : int
  ; time : int
  ; electric_current : int
  ; temperature : int
  ; amount_of_substance : int
  ; luminous_intensity : int
  }

type base_unit =
  | Gram
  | Kilogram
  | Metre
  | Second
  | Ampere
  | Kelvin
  | Mol
  | Candela
  | Unitless
  | Angle

type si_unit =
  | Volt
  | Ohm
  | Coulomb
  | Farad
  | Hertz
  | Newton
  | Radian
  | Degree
  | Steradian
  | Pascal
  | Joule
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

type special_derived_unit =
  | ElectronVolt
  | Minute
  | Hour
  | Curie
  | Angstrom
  | Litre
  | Tonne

type t = (base_unit * int) list

let base_units = [ "m"; "g"; "s"; "sec"; "K"; "mol"; "cd" ]

let si_units =
  [ "V"
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
  ; "J"
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

let dim_of_base_unit = function
  | Metre -> Length
  | Gram | Kilogram -> Mass
  | Second -> Time
  | Ampere -> Electric_current
  | Kelvin -> Temperature
  | Mol -> Amount_of_substance
  | Candela -> Luminous_intensity
  | Unitless -> Dimensionless
  | Angle -> assert false
;;

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
  | NoPrefix -> 0
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

(* TODO: Handle degrees! *)
let base_of_si = function
  | Hertz -> [ Second, -1 ]
  | Radian -> [ Metre, -1; Metre, 1; Unitless, 0 ]
  | Steradian -> [ Metre, -2; Metre, 2; Unitless, 0 ]
  | Newton -> [ Gram, 3; Kilogram, 1; Metre, 1; Second, -2 ]
  | Pascal -> [ Gram, 3; Kilogram, 1; Metre, -1; Second, -2 ]
  | Joule -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -2 ]
  | Watt -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -3 ]
  | Coulomb -> [ Second, 1; Ampere, 1 ]
  | Volt -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -3; Ampere, -1 ]
  | Farad -> [ Gram, -3; Kilogram, -1; Metre, 2; Second, -3; Ampere, -1 ]
  | Ohm -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -3; Ampere, -2 ]
  | Siemens -> [ Gram, -3; Kilogram, -1; Metre, -2; Second, 3; Ampere, 2 ]
  | Weber -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -2; Ampere, -1 ]
  | Tesla -> [ Gram, 3; Kilogram, 1; Second, -2; Ampere, -1 ]
  | Henry -> [ Gram, 3; Kilogram, 1; Metre, 2; Second, -2; Ampere, -2 ]
  | Celsius -> [ Kelvin, 1 ]
  | Lumen -> [ Candela, 1 ]
  | Lux -> [ Candela, 1; Metre, -2 ]
  | Becquerel -> [ Second, -1 ]
  | Gray -> [ Metre, 2; Second, -2 ]
  | Sievert -> [ Metre, 2; Second, -2 ]
  | Katal -> [ Mol, 1; Second, -1 ]
  | Degree -> assert false
;;
