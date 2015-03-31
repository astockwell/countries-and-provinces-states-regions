require '../lib/get_from_wikipedia'

filename = File.basename(__FILE__, ".rb")

GetFromWikipedia.Scrape("PY", filename)
