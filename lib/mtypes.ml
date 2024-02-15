open Why3
open Ptree
open Ptree_helpers

let ty_operation = PTtyapp (qualid ["operation"], [])

let ty_list pty = PTtyapp (qualid ["list"], [pty])

let s_list_operation = Sort.sort_of_pty (ty_list ty_operation)

let ty_mutez = PTtyapp (qualid ["mutez"], [])

let s_mutez = Sort.sort_of_pty ty_mutez

let ty_bool = PTtyapp (qualid ["bool"], [])

let s_bool = Sort.sort_of_pty ty_bool

let ty_address = PTtyapp (qualid ["address"], [])

let s_address = Sort.sort_of_pty ty_address

let ty_option pty = PTtyapp (qualid ["option"], [pty])

let ty_key_hash = PTtyapp (qualid ["key_hash"], [])
