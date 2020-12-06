# Qew

Wrapper around erlang's :queue module. Module keeps track of the queue length.

## Usage

create empty queue:

```elixir
> q = Qew.empty()
{{[], []}, 0}
```

check queue size:

```elixir
> Qew.size(q)
0
```

enqueue some elements:

```elixir
> q = q |> Qew.enqueue(9) |> Qew.enqueue(7) |> Qew.enqueue(12)
> Qew.to_list(q) |> IO.inspect(charlists: :as_lists)
[9, 7, 12]
```

dequeue elements:

```elixir
> {e, q} = Qew.dequeue(q)

> Qew.to_list(q) |> IO.inspect(charlists: :as_lists)
[7, 12]
```

split queue in two:

```elixir
> {q1, q2} = Qew.split(q, 1)

> Qew.to_list(q1) |> IO.inspect(charlists: :as_lists)
[7]

> Qew.to_list(q2) |> IO.inspect(charlists: :as_lists)
[12]
```
