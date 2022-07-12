# README

IIIF Range Prototype

See the following:
* `/app/models` contains `Structure`, `StructureRange`, `StructureCanvas` classes.
* `/app/models/concerns/` contains `IiifRangeBuilder` which has a method to construct a Range hierarchy from IIIF JSON.
* `/app/controllers/` contains a `RangeController` to handle GET/POST/PUT
