# Unsort proposal

## Current type restriction of smart contracts

Currently, the storages and parameters in a tzw file are restricted
to the types isomorphic to Michelson's types: products and sums must be
binary.  This restriction makes it hard to verify smart contracts written in
higher level language than Michelson which support more complex types
such as records and variants.

## Objective and benefits

This proposal removes this restriction of the storage and parameter types.
It will ease verifications of Tezos smart contracts written in higher level
languages and may make Icon possible to verify smart contracts of 
blockchains other than Tezos.

## Why types are restricted ?

Icon auto-generates predicates `storage_wf` and `param_wf` for storage and
parameter values respectively, which can be used as assumptions 
for entrypoint pre and post conditions.

These `wf` functions
are generated for the *sorts* (`Sort.t`) which are isomorphic to Michelson
types. The generation fails when a storage or parameter type cannot be
converted to a sort.

## How to remove the restriction?

- Extend the sorts to Why3 types.
- Extend `wf` function generation to the extended sorts.

### Extend the sorts

The sort is now equivalent with Why3 type `pty`:

```
type t = private Sort of pty
(** Private because [pty] must be normalized for equality *)
```

Since the sorts are 
compared and used as map keys, the types must be normalized: the locations
and the attributes of the identifiers in the types must be removed in the sorts.

### Auto-generate `wf` predicates

For each type with a `[@gen_wf]` attribute defined in the contract scopes,
a predicate `is_<typename>_wf` is auto-generated.  For example, for the type
definition like:

```
  type foo [@gen_wf] 'a = 
    | Woo 'a 
	| Vee 'a (list 'a)
```

The following `wf` predicate is generated:

```
  predicate is_foo_wf (is_'a_wf: 'a -> bool) (_v: foo 'a) =
    match _v with
    | Woo _a0 -> (true /\ (is_'a_wf _a0))
    | Vee _a0 _a1 ->
        ((true /\ (is_'a_wf _a0)) /\ (is_list_wf is_'a_wf _a1))
    end
```

### Auto-generation of `wf` predicates for contract storage and parameters

The auto-generation `wf` predicates are also applied to the storage and
parameter types of contracts:

- A `is_storage_wf` predicate is generated if the type definition of
  `storage` is attributes with `[@gen_wf]` for each contract.
- `param_wf` predicate is always generated for each contract.

### Manual definition of `wf` predicates

`is_<type>_wf` predicates are only auto-generated for type definitions with
`[@gen_wf]` attributes.  Users can define custom `is_<type>_wf` predicates
by hand without the attribute.

### `wf` predicates for primitive types

For the primitive type constructors such as `int`, `nat`, `mutez`, `list`,
tuples, etc. `is_<type>_wf` predicates must be prepared in the preamble.
