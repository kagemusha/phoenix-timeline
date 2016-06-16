# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixTimeline.Repo.insert!(%PhoenixTimeline.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds do
  import Ecto.Query, only: [from: 1, from: 2]
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Card
  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Cardset

  def add_cardset(name, display_name, description, cards) do

    cardset = Repo.insert!(%Cardset{name: name, display_name: display_name, description: description})

    for card_attrs <- cards do
      card_struct = case card_attrs do
         [event, year] -> %Card{ event: event, year: year }
         [event, year, month] -> %Card{ event: event, year: year, month: month }
      end

      card = Repo.insert! card_struct
             |> Repo.preload(:cardsets)

      card
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:cardsets, [ cardset ])
      |> Repo.update!
    end
  end

  def cleanup do
    from(g in Game) |> Repo.delete_all
    from(c in Card) |> Repo.delete_all
    from(cs in Cardset) |> Repo.delete_all
  end
end

Seeds.cleanup

general_cards = [
  ["Humans cross the Bering Straits into the Americas", -15000],
    ["Domestication of plants and animals", -12500],
    ["Beginning of irrigation in Egypt and Mesopotamia", -6000],
    ["Hammurabi becomes king of Babylon", -1792],
    ["Solomon becomes king of Israel", -970],
    ["Founding of Carthage", -813],
    ["First recorded Olympic Games", -776],
    ["Nebuchadnezzar II of Babylon conquers Judah", -586],
    ["Cyrus the Great conquers Babylon", -538],
    ["Athenians defeat Persians at Battle of Marathon", -490],
    ["300 Spartans overrun at Thermopylae", -480],
    ["Parthenon completed in Athens", -432],
    ["Athens surrenders to Sparta to end Peloponnesian War", -404],
    ["Alexander becomes King of Macedon", -336],
    ["Alexander decisively defeats Persians at Gaugamela", -331],
    ["Death of Alexander the Great", -323],
    ["Qin Shi Huang unifies China, declares himself first Emperor", -220],
    ["Liu Bang found Chinese Han Dynasty", -206],
    ["Henry VIII executes Ann Boleyn", -206],
    ["Destruction of Carthage", -146],
    ["Caesar crosses the Rubicon", -49],
    ["Assassination of Caesar", -44],
    ["Death of Cleopatra", -30],
    ["Start of First Jewish-Roman War", 66],
    ["First Goth raid on the Roman Empire", 238],
    ["Vandals sack Rome", 455],
    ["Charlemagne crowned Holy Roman Emperor", 800],
    ["Norman Invasion", 1066],
    ["First Crusade launched", 1096],
    ["Magna Carta", 1215],
    ["Mongol Yuan Dynasty declared in China", 1271],
    ["First Mongol invasion of Japan", 1274],
    ["Onset of the Black Death in Europe", 1348],
    ["Advent of the Ming Dynasty in China", 1368],
    ["Invention of the Printing Press", 1440],
    ["Fall of Constatinople to the Turks", 1453],
    ["Columbus discovers Americas", 1492],
    ["Luther's 95 Theses ushers in the Protestant Reformation", 1517],
    ["First circumnavigation of the world", 1522],
    ["Battle of Panipat marks start of Mughal Empire in India", 1526],
    ["Suleiman the Magnificent besieges Vienna", 1529],
    ["Charles V crowned Holy Roman Emperor", 1530],
    ["Spanish Armada", 1588],
    ["Battle of Sekigahara assures Tokugawa supremacy in Japan", 1600],
    ["Dutch purchase Manhattan", 1626],
    ["Newton publishes law of gravitation", 1687],
    ["US Declaration of Independence", 1776],
    ["Storming of the Bastille", 1789],
    ["Burr kills Hamilton in duel", 1804],
    ["Napoleon crowned Emperor", 1804],
    ["Battle of Austerlitz", 1805],
    ["Nelson defeats French at Trafalgar", 1805],
    ["Napoleon invades Russia", 1812],
    ["Battle of Waterloo", 1815],
    ["Venezuela under Bolivar achieves independence", 1821],
    ["Piggery Wars drive hogs out of Manhattan", 1859],
    ["Battle of Fort Sumter starts of US Civil War", 1861],
    ["Invention of the telephone", 1876],
    ["New Zealand first country to allow women to vote", 1893],
    ["First flight", 1903],
    ["Russo-Japanese War ends in Russian defeat", 1905],
    ["Einstein announces theory of relativity", 1905],
    ["Sinking of the Titanic", 1913],
    ["Outbreak of WWI", 1914],
    ["Archduke Franz Ferdinand assassinated in Sarajevo", 1914],
    ["Russian Revolution", 1917],
    ["Discovery of Penicillin", 1928],
    ["Black Thursday ushers in the Great Depression", 1929],
    ["World War II begins with German invasion of Poland", 1939],
    ["India and Pakistan gain independence from Britain", 1947],
    ["Communist Takeover of China", 1949],
    ["Sputnik launch, first man-made satellite to orbit earth", 1957],
    ["Yuri Gagarin becomes first human in outer space", 1961],
    ["First Moon Landing", 1969],
    ["Nelson Mandela released from prison", 1990],
    ["Louisiana Purchase", 1803],
    ["US purchases Alaska from Russia",1867],
    ["Vesuvius eruption buries Pompeii", 79],
    ["Visigoths sack Rome", 410],
    ["Roman legions evacuate Britannia", 406],
    ["The Goths cross into the Roman Empire", 376],
    ["Goths destroy a Roman army at Adrianople", 378],
    ["Founding of the Pony Express", 1860],
    ["End of the 100 Years' War", 1453],
    ["Defenestration of Prague sparks 30 Years' War", 1618],
    ["Declaration of the Rights of Man", 1789],
    ["Tennis Court Oath", 1789],
    ["Death of the King in Memphis", 1977],
    ["1st Modern Olympic Games", 1896],
    ["Jessie Owens in Berlin", 1936],
    ["I Have a Dream speech", 1963],
    ["Edward Drake drills 1st oil well", 1859],
    ["Start of 100 Years' War", 1337],
    ["Suez Canal opens", 1869],
    ["Panama Canal opens", 1914],
    ["US gives control of Panama Canal to Panama", 1999],
    ["Hannibal annihilates Romans at Battle of Cannae", -216],
    ["Hannibal crosses the Alps", -218],
    ["1st Pyramid", -2650],
    ["Joan of Arc burned at the stake", 1431],
    ["Scots win independence at Battle of Bannockburn", 1314],
    ["Founding of the Swiss Confederation", 1291],
    ["Assassination of JFK", 1963],
    ["Berlin Airlift starts", 1948],
    ["Start of the 1st Gulf War", 1991],
    ["Lindberg becomes 1st to fly across the Atlantic", 1927],
    ["France abolishes the death penalty", 1981],
    ["Congress establishes the US Mint", 1792],
    ["Don Juan defeat the Turkish fleet at Lepanto", 1571],
    ["Battle of the Alamo", 1836],
    ["Woodstock", 1969],
    ["Napoleon crowned Emperor of France", 1804],
    ["1st man on the moon", 1969],
    ["Salem witch trials", 1692],
    ["Introduction of the Euro", 1999],
    ["France abolishes slavery", 1848],
    ["Great Fire of London", 1666],
    ["San Francisco earthquake", 1906],
    ["Nero fiddles while Rome burns", 64],
    ["King Kong", 1933],
    ["Gone with the Wind", 1939],
    ["Hamlet published", 1603],
    ["Cervantes publishes Don Quijote", 1605],
    ["The Great Buddha in Kamakura", 1252 ],
    ["Mamluks halt Mongol expansion at Ain Jalut", 1260],
    ["Peter the Great beat Swedes at Poltava", 1709],
    ["End of World War II", 1945],
    ["Danish viking Canute becomes King of England", 1016],
    ["Galileo discovers Saturn, a planet with ears", 1610],
    ["Darwin publishes theory of evolution", 1859],
    ["I think therefore I am", 1637],
    ["Triangle Factory Fire in New York City", 1911],
    ["Al Capone arrested for tax evasion", 1931],
    ["Prohibition enacted", 1920],
    ["Henry IV crowned King of France after converting to Catholicism", 1594],
    ["Advent of the Ford Model T", 1908],
    ["Turkish sultan Suleiman the Magnificent beseiges Vienna", 1529],
    ["Shaka becomes chief of the Zulu", 1816],
    ["Zulus wipe out the British at Islandlwhana", 1879],
    ["First working railway locomotive", 1804],
    ["Lewis and Clark Expedition sets off", 1804],
    ["The Church of England leaves Catholic Church", 1538],
    ["Magellan killed in the Philippines", 1521],
    ["Jackie Robinson breaks into the Major Leagues", 1947],
    ["The Suez Crisis", 1956],
    ["Temujin becomes Genghis Khan, ruler of all the Mongols", 1206],
    ["Attila and brother Bleda become kings of the Huns", 434],
    ["Premiere of the Ring Cycle at Bayreuth", 1876],
    ["Mongols invade Rus", 1237],
    ["Mongols sack Baghdad", 1258],
    ["Muhammad embarks on the Hijra", 622]
  ]



peep_cards = [
  ["First Ember.js NYC meetup", 2012, 3],
  ["First Sproutcore NYC meetup", 2011, 1],
  ["Ember app kit", 2013, 5],
  ["Ember-cli", 2013, 10],
  ["Advent of Ember", 2011 , 11],
  ["Fastboot announced", 2014, 11],
  ["Ember.js 1.0 released", 2013, 7],
  ["Glimmer lands", 2015, 5],

#  ["Stable Ember data", ,],
#  ["First new Ember router", ,],
#  ["Second new Ember router", ,],
#  ["HTMLBars finished", ,],
#  ["Ember inspector appears", ,],
#  ["Ember is slow crisis!", ,],
#  ["Emblem.js", ,],
#  ["First Ember Conf", ,],
#  ["", ,],
]

Seeds.add_cardset "general", "General history", "General historical events", general_cards
Seeds.add_cardset "peep", "Peep stack", "Peep stack (phoenix, elixir, ember, postgres) related events", peep_cards
