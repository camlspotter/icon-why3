(** Sorts for the FOL theory used as the assertion language *)

open Why3.Ptree

type t = private Sort of pty
(** Private because [pty] must be normalized for equality *)

val equal : t -> t -> bool

val compare : t -> t -> int

val pp_sort : Format.formatter -> t -> unit
(** Pretty printer *)

val string_of_sort : t -> string

val sort_of_pty : pty -> t
(** Parse a [pty] value as a Michelson type and convert into a [Sort.t] value. *)

val pty_of_sort : t -> pty
(** Convert [t] value into [pty] value.  *)
