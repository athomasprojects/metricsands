# TODO

- String representation of quantities: `<magnitude>_<unit>`. -> Ex: "1.5_kg"
  - We'll need to parse the string to into the "magnitude" and "unit" portions.
  - Identify "magnitude" (if exists). -> We will not be checking the 'reasonableness' of the magnitude, only that it is in fact a number. The client is expected to ensure that all magnitudes are valid from a physical perspective.
  - Parse unit "unit" -> identify each base unit and their respective accompanying prefixes. The prefix gives us the exponent of the unit and the base units let us know how the units can be combined.

- Need to determine what the our rules for combining units will be.
  - Fundamental operations -> i.e. multiplication, division, exponentiation, addition, subtraction
  - Probably want to tag our set of physical units with a dimensionality property to define how units can be combined. -> I'm thinking of a framework along the lines of how we carry out dimensional analysis. There's still some abstractness however, because of the possibility of `derived units` which will have their own sets of combination rules...Maybe we just boil everything down to 'base units' and combine the units according to the rules for our more restricted set of base units?

