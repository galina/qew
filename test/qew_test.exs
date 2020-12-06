defmodule QewTest do
  use ExUnit.Case

  describe "drop/1" do
    test "does nothing with empty queue" do
      assert Qew.drop(Qew.empty()) == Qew.empty()
    end

    test "drops head if queue is not empty" do
      queue = Qew.from_list([1, 2, 3])
      assert Qew.to_list(queue) == [1, 2, 3]

      queue = Qew.drop(queue)
      assert Qew.to_list(queue) == [2, 3]

      queue = Qew.drop(queue)
      assert Qew.to_list(queue) == [3]

      queue = Qew.drop(queue)
      assert Qew.to_list(queue) == []
    end
  end

  describe "drop_n/2" do
    test "does nothing with empty queue" do
      assert Qew.drop_n(Qew.empty(), 20) == Qew.empty()
    end

    test "drops n items" do
      initial_queue = Qew.from_list([1, 2, 3])

      queue = Qew.drop_n(initial_queue, 20)
      assert Qew.to_list(queue) == []

      queue = Qew.drop_n(initial_queue, 3)
      assert Qew.to_list(queue) == []

      queue = Qew.drop_n(initial_queue, 2)
      assert Qew.to_list(queue) == [3]

      queue = Qew.drop_n(initial_queue, 1)
      assert Qew.to_list(queue) == [2, 3]
    end
  end

  describe "size/1" do
    test "returns empty queue size" do
      assert Qew.size(Qew.empty()) == 0
    end

    test "returns queue size" do
      assert Qew.size(Qew.from_list([1, 2, 3, 4, 5])) == 5
      assert Qew.size(Qew.from_list([1])) == 1
      assert Qew.size(Qew.from_list([])) == 0
    end
  end

  describe "peek/1" do
    test "peeks empty queue" do
      assert Qew.peek(Qew.empty()) == nil
    end

    test "peeks non empty queue" do
      assert Qew.peek(Qew.from_list([12, 2, 3, 4, 5])) == 12
    end
  end

  describe "dequeue/1" do
    test "dequeues nil if queue is empty" do
      assert Qew.dequeue(Qew.empty()) == {nil, Qew.empty()}
    end

    test "returns head value" do
      initial_queue = Qew.from_list([6, 1, 2, 3, 4, 5])

      assert {6, queue} = Qew.dequeue(initial_queue)
      assert Qew.to_list(queue) == [1, 2, 3, 4, 5]

      assert {1, queue} = Qew.dequeue(queue)
      assert Qew.to_list(queue) == [2, 3, 4, 5]

      assert {5, queue} = Qew.dequeue(Qew.from_list([5]))
      assert Qew.to_list(queue) == []
    end
  end

  describe "enqueue/1" do
    test "enqueues element into empty queue" do
      queue = Qew.enqueue(Qew.empty(), 8)

      assert Qew.to_list(queue) == [8]
    end

    test "enqueues element if queue is not empty" do
      initial_queue = Qew.from_list([6, 1, 2, 3, 4, 5])

      queue = Qew.enqueue(initial_queue, 18)
      assert Qew.to_list(queue) == [6, 1, 2, 3, 4, 5, 18]
    end
  end

  describe "enqueue_head/2" do
    test "prepends element into empty queue" do
      queue = Qew.enqueue(Qew.empty(), 8)

      assert Qew.to_list(queue) == [8]
    end

    test "prepends element if queue is not empty" do
      initial_queue = Qew.from_list([6, 1, 2, 3, 4, 5])

      queue = Qew.enqueue_head(initial_queue, 18)
      assert Qew.to_list(queue) == [18, 6, 1, 2, 3, 4, 5]
    end
  end

  describe "empty/1" do
    test "returns new queue" do
      assert Qew.empty() == {:queue.new(), 0}
    end
  end

  describe "split/2" do
    test "does nothing with empty queue" do
      assert Qew.split(Qew.empty(), 0) == {Qew.empty(), Qew.empty()}
      assert Qew.split(Qew.empty(), 1) == {Qew.empty(), Qew.empty()}
      assert Qew.split(Qew.empty(), 10) == {Qew.empty(), Qew.empty()}
      assert Qew.split(Qew.from_list([]), 3) == {Qew.empty(), Qew.empty()}
    end

    test "splits non empty queue" do
      {queue1, queue2} = Qew.split(Qew.from_list([1]), 0)
      assert Qew.to_list(queue1) == [1]
      assert queue2 == Qew.empty()

      {queue1, queue2} = Qew.split(Qew.from_list([1, 2, 3]), 0)
      assert Qew.to_list(queue1) == [1, 2, 3]
      assert queue2 == Qew.empty()

      {queue1, queue2} = Qew.split(Qew.from_list([1]), 4)
      assert Qew.to_list(queue1) == [1]
      assert queue2 == Qew.empty()

      {queue1, queue2} = Qew.split(Qew.from_list([1]), 1)
      assert Qew.to_list(queue1) == [1]
      assert queue2 == Qew.empty()

      {queue1, queue2} = Qew.split(Qew.from_list([11, 13]), 1)
      assert Qew.to_list(queue1) == [11]
      assert Qew.to_list(queue2) == [13]

      {queue1, queue2} = Qew.split(Qew.from_list([13, 11]), 1)
      assert Qew.to_list(queue1) == [13]
      assert Qew.to_list(queue2) == [11]

      {queue1, queue2} = Qew.split(Qew.from_list([13, 11, 14]), 1)
      assert Qew.to_list(queue1) == [13]
      assert Qew.to_list(queue2) == [11, 14]

      {queue1, queue2} = Qew.split(Qew.from_list([13, 11, 14]), 2)
      assert Qew.to_list(queue1) == [13, 11]
      assert Qew.to_list(queue2) == [14]

      {queue1, queue2} = Qew.split(Qew.from_list([13, 17, 15]), 3)
      assert Qew.to_list(queue1) == [13, 17, 15]
      assert queue2 == Qew.empty()
    end
  end

  describe "join/2" do
    test "joins empty queues" do
      assert Qew.join(Qew.empty(), Qew.empty()) == Qew.empty()
    end

    test "joins queues" do
      joined = Qew.join(Qew.from_list([9, 81, 4]), Qew.empty())
      assert Qew.to_list(joined) == [9, 81, 4]

      joined = Qew.join(Qew.empty(), Qew.from_list([15, 0]))
      assert Qew.to_list(joined) == [15, 0]

      joined = Qew.join(Qew.from_list([1]), Qew.from_list([2]))
      assert Qew.to_list(joined) == [1, 2]

      joined = Qew.join(Qew.from_list([2]), Qew.from_list([1]))
      assert Qew.to_list(joined) == [2, 1]
    end
  end

  describe "enqueue_list/2" do
    test "enqueues list into empty queue" do
      queue = Qew.enqueue_list(Qew.empty(), [4, 7, 10])
      assert Qew.to_list(queue) == [4, 7, 10]

      queue = Qew.enqueue_list(Qew.empty(), [])
      assert Qew.to_list(queue) == []
    end

    test "enqueues list into non empty queue" do
      initial_queue = Qew.from_list([9, 0, 3])

      queue = Qew.enqueue_list(initial_queue, [4, 7, 10])
      assert Qew.to_list(queue) == [9, 0, 3, 4, 7, 10]

      queue = Qew.enqueue_list(initial_queue, [])
      assert Qew.to_list(queue) == [9, 0, 3]
    end
  end
end
