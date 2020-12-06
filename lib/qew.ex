defmodule Qew do
  @moduledoc """
  Wrapper around erlang `:queue` module.

  Module keeps track of the queue length.
  """

  @doc false
  def to_list({_queue, 0}), do: []
  def to_list({queue, _size}), do: :queue.to_list(queue)

  @doc false
  def from_list([]), do: empty()

  def from_list(list) do
    Qew.enqueue_list(empty(), list)
  end

  @doc """
  Drops element from queue.
  """
  def drop({queue, 0}), do: {queue, 0}
  def drop({queue, size}), do: {:queue.drop(queue), size - 1}

  @doc """
  Drops n elements from queue.
  """
  def drop_n({queue, 0}), do: queue

  def drop_n(queue, n) when is_integer(n) do
    Enum.reduce_while(1..n, queue, fn _, acc ->
      acc = drop(acc)

      if empty?(acc) do
        {:halt, acc}
      else
        {:cont, acc}
      end
    end)
  end

  @doc """
  Enqueue list elements.
  """
  def enqueue_list(queue, values) do
    Enum.reduce(values, queue, fn value, acc -> enqueue(acc, value) end)
  end

  @doc """
  Joins two queues.
  """
  def join(queue1, {_, 0}), do: queue1
  def join({_, 0}, queue2), do: queue2

  def join(queue1, {_, n} = queue2) do
    {queue1, _} =
      Enum.reduce(1..n, {queue1, queue2}, fn _, {queue1, queue2} ->
        {value, queue2} = dequeue(queue2)

        {enqueue(queue1, value), queue2}
      end)

    queue1
  end

  @doc """
  Splits queue in two. First queue contains n elements.
  """
  def split(queue, 0), do: {queue, empty()}

  def split(queue, n) when is_integer(n) do
    if size(queue) <= n do
      {queue, empty()}
    else
      split_n(queue, n)
    end
  end

  @doc """
  Returns queue size.
  """
  def size({_, size}), do: size

  @doc """
  Returns empty queue.
  """
  def empty, do: {:queue.new(), 0}

  def empty?({_queue, size}), do: size == 0

  @doc """
  Returns head element.

  Returns `nil` if queue is empty.
  """
  def peek({_queue, 0}), do: nil

  def peek({queue, _size}) do
    {:value, value} = :queue.peek(queue)

    value
  end

  @doc """
  Dequeues head element.

  Returns {nil, empty_queue} if queue is empty.
  Returns {value, updated_queue} if queue is not empty.
  """
  def dequeue({_, 0} = q), do: {nil, q}

  def dequeue({queue, size}) do
    {{:value, value}, queue} = :queue.out(queue)

    {value, {queue, size - 1}}
  end

  @doc """
  Add element into queue head.
  """
  def enqueue_head({queue, size}, value) do
    {:queue.in_r(value, queue), size + 1}
  end

  @doc """
  Enqueue element.
  """
  def enqueue({queue, size}, value) do
    {:queue.in(value, queue), size + 1}
  end

  defp split_n(queue, n) do
    Enum.reduce(1..n, {empty(), queue}, fn _, {queue1, queue2} ->
      {value, queue2} = dequeue(queue2)

      {enqueue(queue1, value), queue2}
    end)
  end
end
