# This is a container for items of data supplied by the tree model.

class TreeItem

  attr_reader :childItems

  def initialize(data, parent=nil)
    @parentItem = parent
    @itemData = data
    @childItems = Array.new
  end

  def appendChild(item)
    @childItems.push(item)
  end

  def child(row)
    return @childItems[row]
  end

  def childCount
    return @childItems.length
  end

  def childRow(item)
    return @childItems.index(item)
  end

  def columnCount
    return @itemData.length
  end

  def data(column)
    return @itemData[column]
  end

  def parent
    return @parentItem
  end

  def row
    if ! @parentItem.nil?
      return @parentItem.childRow(self)
    end
    return 0
  end

end
