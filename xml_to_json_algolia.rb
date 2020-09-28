require 'nokogiri'
require 'byebug'
require 'ox'
require 'json'

# Load the xml file.
doc = File.open("output.xml") { |f| Ox.load(f.read) }

doc.root

json_object = []

doc.root.nodes.each do |nodes|
  item = {}

  nodes.each do |node|
    item[node.attributes[:name]] = node.text
  end

  # tags from object to array
  if item["tags"]
    item["tags"] = item["tags"].split(",")
  end

  # categories_ja from object to array
  if item["categories_ja"]
    item["categories_ja"] = item["categories_ja"].split(",")
  end

  # place_id from string to int
  if item["place_id"]
    item["place_id"] = item["place_id"].to_i
  end

  # object_id to "objectID"
  if item["object_id"]
    item["objectID"] = item["object_id"]
    item.delete("object_id")
  end

  json_object << item
end

File.open("output.json", "w") { |f| f.write(json_object.to_json) }
