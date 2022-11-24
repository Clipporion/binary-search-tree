class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
    @rebalance = []
  end
end

class Tree
  attr_accessor :root, :array

  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = (array.length) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array[0...mid])
    node.right = build_tree(array[(mid + 1)..])
    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    if node.nil?
      Node.new(value)
    elsif node.data > value
      node.left = insert(value, node.left)
      node
    elsif node.data <= value
      node.right = insert(value, node.right)
      node
    end
  end

  def delete(value, node = @root)
    return if node.nil?

    if node.data == value
      if !node.left.nil? && !node.right.nil?
        node.data = find_successor(node).data
        node.right = delete(find_successor(node).data, node.right)
        node
      elsif !node.left.nil?
        node.left
      elsif !node.right.nil?
        node.right
      else
        nil
      end
    elsif value < node.data
      node.left = delete(value, node.left)
      node
    elsif value > node.data
      node.right = delete(value, node.right)
      node
    end
  end

  def find(value, node = @root)
    return node if node.nil? || node.data == value

    if value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def find_successor(node)
    successor = node.right
    until successor.left.nil?
      successor = successor.left
    end
    successor
  end

  def level_order(queue = [@root])
    result = []
    if block_given?
      until queue.empty?
        queue.push(queue[0].left) if queue[0].left
        queue.push(queue[0].right) if queue[0].right
        yield queue.shift
      end
    else
      until queue.empty?
        queue.push(queue[0].left) if queue[0].left
        queue.push(queue[0].right) if queue[0].right
        result.push(queue.shift.data)
      end
      result.uniq.sort
    end
  end

  def level_order_rec(node = @root, queue)
    print "#{node.data} "
    queue.push(node.left) if node.left
    queue.push(node.right) if node.right
    return if queue.empty

    level_order_rec(queue.shift, queue)
  end

  def inorder(node = @root)
    return if node.nil?
    inorder(node.left)
    print "#{node.data} "
    inorder(node.right)
  end

  def preorder(node = @root)
    return if node.nil?
    print "#{node.data} "
    preorder(node.left)
    preorder(node.right)
  end

  def postorder(node = @root)
    return if node.nil?
    postorder(node.left)
    postorder(node.right)
    print "#{node.data} "
  end

  def height(node = @root)
    return -1 if node.nil?

    left_path = height(node.left)
    right_path = height(node.right)
    left_path > right_path ? left_path + 1 : right_path + 1
  end

  def depth(node = @root, root = @root, result = 0)
    return 'Node not found' if node.nil?
    return result if node.data == root.data

    if node.data < root.data
      depth(node, root.left, result += 1)
    else
      depth(node, root.right, result += 1)
    end
  end

  def balanced?
    left_path = height(@root.left)
    right_path = height(@root.right)

    if left_path > right_path + 1 || right_path > left_path + 1
      false
    else
      true
    end
  end

  def rebalance
    if !balanced?
      puts 'Tree not balanced, rebalancing initialized'
      @rebalance = level_order
      @root = build_tree(@rebalance)
      pretty_print
    else
      puts "Tree is balanced"
    end
  end
end

newtree = Tree.new(Array.new(15) { rand(0..100) })
newtree.pretty_print
puts newtree.balanced?
puts newtree.preorder
puts newtree.inorder
puts newtree.postorder
6.times { newtree.insert(rand(100..200)) }
newtree.pretty_print
puts newtree.balanced?
newtree.rebalance
puts newtree.balanced?
