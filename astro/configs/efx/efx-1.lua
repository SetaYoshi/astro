local ID = ID

EFX.register{
  id = ID,
  name = 'mario-jump',

  efxcreate = function(efx)
    SFX.new('player-jump')

    efx.finished = true
  end,
}