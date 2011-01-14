require 'slackware/gui/tree_item'

# Provides a simple tree model that displays the content of the DICOM file.
class TreeModel < Qt::AbstractItemModel

  def initialize(obj, parent=nil)
    super(parent)
    rootData = Array.new
    rootData << Qt::Variant.new("Name") << Qt::Variant.new("Value")
    @rootItem = TreeItem.new(rootData)
    process_children(obj.children, @rootItem)
  end

  def columnCount(parent)
    if parent.valid?
      return parent.internalPointer.columnCount
    else
      return @rootItem.columnCount
    end
  end

  def data(index, role)
    if !index.valid?
      return Qt::Variant.new
    end
    if role != Qt::DisplayRole
      return Qt::Variant.new
    end
    item = index.internalPointer
    return Qt::Variant.new(item.data(index.column))
  end

  def flags(index)
    if !index.valid?
      return Qt::ItemIsEnabled
    end
    return Qt::ItemIsEnabled | Qt::ItemIsSelectable
  end

  def headerData(section, orientation, role = Qt::DisplayRole)
    if orientation == Qt::Horizontal && role == Qt::DisplayRole
      return @rootItem.data(section)
    end
    return Qt::Variant.new
  end

  def index(row, column, parent)
    if !parent.valid?
      parentItem = @rootItem
    else
      parentItem = parent.internalPointer
    end
    @childItem = parentItem.child(row)
    if ! @childItem.nil?
      return createIndex(row, column, @childItem)
    else
      return Qt::ModelIndex.new
    end
  end

  def parent(index)
    if !index.valid?
      return Qt::ModelIndex.new
    end
    childItem = index.internalPointer
    parentItem = childItem.parent
    if parentItem == @rootItem
      return Qt::ModelIndex.new
    end
    return createIndex(parentItem.row, 0, parentItem)
  end

  def rowCount(parent)
    if !parent.valid?
      parentItem = @rootItem
    else
      parentItem = parent.internalPointer
    end
    return parentItem.childCount
  end

  def process_children(children, parent)
    # Iterate over all children and repeat recursively for any child which is parent:
    children.each do |element|
      if element.children?
        current_item = TreeItem.new([element.name, nil], parent)
        parent.appendChild(current_item)
        process_children(element.children, current_item)
      elsif element.is_a?(Slackware::Package)
        parent.appendChild(TreeItem.new([element.name, element.value], parent))
      end
    end
  end

end
