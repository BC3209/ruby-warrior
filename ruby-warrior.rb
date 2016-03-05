class Player

  def initialize
    @health = 20
  end

  def play_turn(warrior)

    walking = Walk.new(warrior)
    attack = Attack.new(warrior)
    rest = WarriorRest.new(warrior)
    health = WarriorHealth.new(warrior)
    captive = RescueCaptive.new(warrior)
    low_health = WarriorHealthLow.new(warrior)
    pivot = WarriorPivot.new(warrior)
    shoot = WarriorShoot.new(warrior)

    # action_array = [walking, attack, health, low_health, rest, captive]
    # action_array = [pivot, attack, low_health, health, captive, rest, walking]
    # action_array = [health, low_health, walking, attack, rest]
    # action_array = [attack, shoot, low_health, health, captive, walking]
    action_array = [shoot, captive, walking]

    action_array.each do |item|
      # return health at the end of each turn
      if item.question?(@health)
         item.action!
         break
       end
    end
    @health = warrior.health
  end
end


class InitializeWarrior
  def initialize(warrior)
    @warrior = warrior
  end
end


class Walk < InitializeWarrior
  def question?(health)
     @warrior.feel.empty?
  end

  def action!
    @warrior.walk!
  end
end

class Attack < InitializeWarrior
  def question?(health)
    !@warrior.feel.empty?
  end

  def action!
    @warrior.attack!
  end
end

class WarriorRest < InitializeWarrior
  def question?(health)
   if @warrior.health < 10
     true
   end
  end

  def action!
    @warrior.rest!
  end
end

class WarriorHealth < InitializeWarrior
  def question?(health)
    @warrior.health < 20 && @warrior.health >= health
  end

  def action!
    @warrior.rest!
  end
end

class RescueCaptive < InitializeWarrior
  def question?(health)
    @warrior.feel.captive?
  end

  def action!
    @warrior.rescue!
  end
end

class WarriorHealthLow < InitializeWarrior
  def question?(health)
     @warrior.health < health && @warrior.feel(:backward).empty? && @warrior.health < 12
  end

  def action!
    @warrior.walk!(:backward)
  end
end

class WarriorPivot < InitializeWarrior
  def question?(health)
    @warrior.feel.wall?
  end

  def action!
    @warrior.pivot!
  end
end

class WarriorShoot < InitializeWarrior
  def question?(health)
    # Returns true if the block never returns false of nil
    # does any space contain an enemy? && !(does any space contain a captive?)
    # if both of these are true, perform the action
    @warrior.look.any? { |space| space.enemy? } && !@warrior.look.any? { |space| space.captive? }
  end

  def action!
    @warrior.shoot!
  end
end
# You can walk backward by passing ':backward' as an argument to walk!.
# Same goes for feel, rescue! and attack!. Archers have a limited attack distance.

# Walk backward if you are taking damage from afar and do not have enough health to attack.
# You may also want to consider walking backward until warrior.feel(:backward).wall?.
