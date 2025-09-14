# BattleScribe Roster YAML Structure

This document outlines the structure of a BattleScribe roster exported as a YAML file, based on the `test_roster.yml` example. The structure is hierarchical, with key elements described below.

## Root Level
- `id`: Unique identifier for the roster.
- `name`: Name of the roster.
- `battleScribeVersion`: Version of BattleScribe used to generate the roster.
- `generatedBy`: Source of the roster generation (e.g., website).
- `gameSystemId`: Unique identifier for the game system.
- `gameSystemName`: Name of the game system (e.g., "Warhammer Fantasy Battle 6th edition").
- `gameSystemRevision`: Revision number of the game system.
- `xmlns`: XML namespace, typically `http://www.battlescribe.net/schema/rosterSchema`.

## Costs
The `costs` section details the total values for various cost types within the roster.
- `cost`: A list of cost items.
  - `name`: Name of the cost (e.g., "pts", "Dispel Dice", "Casting Dice").
  - `typeId`: Unique identifier for the cost type.
  - `value`: The numerical value of the cost.

## Cost Limits
The `costLimits` section specifies the maximum allowed values for various cost types.
- `costLimit`: A list of cost limit items, similar in structure to `costs`.
  - `name`: Name of the cost limit.
  - `typeId`: Unique identifier for the cost type.
  - `value`: The maximum numerical value allowed.

## Forces
The `forces` section contains details about each force or detachment in the roster.
- `force`: A list of force objects.
  - `id`: Unique identifier for the force.
  - `name`: Name of the force (e.g., "Standard").
  - `entryId`: Entry ID for the force.
  - `catalogueId`: Catalogue ID from which the force is drawn.
  - `catalogueRevision`: Revision of the catalogue.
  - `catalogueName`: Name of the catalogue (e.g., "Chaos").
  - `selections`: Contains the units and characters within this force.
    - `selection`: A list of selection objects, representing units, characters, or upgrades.
      - `id`: Unique identifier for the selection.
      - `name`: Name of the selection (e.g., "Lord of Chaos", "Chaos Armour*", "Hand Weapon").
      - `entryId`: Entry ID for the selection.
      - `number`: Quantity of this selection.
      - `type`: Type of selection (e.g., "unit", "upgrade", "model").
      - `from`: Origin of the selection (e.g., "entry", "group").
      - `entryGroupId`: (Optional) Group ID for the selection, if it originates from a group.
      - `profiles`: (Optional) Contains the profiles for the selection.
        - `profile`: A list of profile objects.
          - `id`: Unique identifier for the profile.
          - `name`: Name of the profile (e.g., "Lord of Chaos", "Hand Weapon").
          - `hidden`: Boolean indicating if the profile is hidden.
          - `typeId`: Unique identifier for the profile type.
          - `typeName`: Name of the profile type (e.g., "Profile", "Weapon", "Armour").
          - `from`: Origin of the profile.
          - `characteristics`: Contains the characteristics of the profile.
            - `characteristic`: A list of characteristic objects.
              - `name`: Name of the characteristic (e.g., "Mv", "WS", "S", "Range", "Saving Throw Modifier").
              - `typeId`: Unique identifier for the characteristic type.
              - `__content__`: The value of the characteristic.
      - `rules`: (Optional) Contains special rules for the selection.
        - `rule`: A list of rule objects.
          - `id`: Unique identifier for the rule.
          - `name`: Name of the rule (e.g., "Chaos Armour", "Frenzy").
          - `hidden`: Boolean indicating if the rule is hidden.
          - `page`: (Optional) Page number in the rulebook.
          - `description`:
            - `__content__`: The detailed description of the rule.
      - `costs`: (Optional) Contains specific costs for the selection.
        - `cost`: Similar to the top-level `costs` section.
      - `categories`: (Optional) Contains categories associated with the selection.
        - `category`: A list of category objects.
          - `id`: Unique identifier for the category.
          - `name`: Name of the category (e.g., "Lord", "Core", "Special").
          - `entryId`: Entry ID for the category.
          - `primary`: Boolean indicating if it's a primary category.

## Categories (at Force Level)
The `categories` section at the force level lists the categories relevant to the entire force.
- `category`: A list of category objects, similar to those found within a selection.
  - `name`: Name of the category.
  - `id`: Unique identifier for the category.
  - `primary`: Boolean indicating if it's a primary category.
  - `entryId`: Entry ID for the category.

This structure provides a comprehensive overview of how BattleScribe rosters are organized in YAML, which should be helpful for parsing and utilizing exported rosters.
