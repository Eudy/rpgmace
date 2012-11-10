#==============================================================================
# Eudy_SwapOnMap
#------------------------------------------------------------------------------
# Permet de permuter sur la carte les membres de l'�quipe en utilisant une
# touche sp�cifique (par d�faut W)
#------------------------------------------------------------------------------
# Version 1.1 - 21/10/2012
#------------------------------------------------------------------------------

$imported = {} if $imported.nil?
$imported["EUDY-SWAPONMAP"] = 1.1

#------------------------------------------------------------------------------
# Modes de permutation
#------------------------------------------------------------------------------
# Par d�faut le mode chenille (1) effectue le d�roulement suivant :
# ORDRE DES PERSONNAGES :
# AVANT=> APRES
# 1 2 3 4 => 2 3 4 1
#------------------------------------------------------------------------------
# Le mode �change (2) effectue le d�roulement suivant :
# ORDRE DES PERSONNAGES :
# AVANT=> APRES
# 1 2 3 4 => 2 1 3 4
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Ce script n�cessite le script Input par OriginalWij et Yanfly
# pour la gestion des touches avanc�es (W)
# Si vous voulez utiliser une touche par d�faut prise en charge par RPG Maker
# ce script deviens facultif, il suffit alors de changer SWAP_KEY
# ex: SWAP_KEY = :C
# Correspond � la touche Entr�e/Espace par d�faut de RPG Maker
#------------------------------------------------------------------------------

# CONFIGURATION
module EUDY
  module SWAP_ON_MAP
    # Touche de permutation
    SWAP_KEY    = Input::LETTERS['W']
    # Mode de permutation
    # 1 chenille
    # 2 �change
    SWAP_MODE   = 1
    # Effet sonore avant d�lai de changement (nil si aucune)
    SWAP_SE = "Evasion2"
    # D�lai avant changement
    SWAP_DELAY = 20
    # Animation avant d�lai de changement (nil si aucune)
    SWAP_ANIM = 109
  end
end

#==============================================================================
# � Scene_Map
#==============================================================================
class Scene_Map
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #     main:  Interpreter update flag
  #--------------------------------------------------------------------------
  alias eudy_swaponmap_update update
  def update(main = false)
    eudy_swaponmap_update
    update_swap
  end

  #--------------------------------------------------------------------------
  def can_switch?
    return !$game_message.busy? && !$game_message.visible && $game_party.members.size > 1 
  end
  
  #--------------------------------------------------------------------------
  def update_swap
    if(Input.trigger?(EUDY::SWAP_ON_MAP::SWAP_KEY) && can_switch?)
      if(EUDY::SWAP_ON_MAP::SWAP_MODE==1)
        Audio.se_play("Audio/SE/"+EUDY::SWAP_ON_MAP::SWAP_SE,70,100) if EUDY::SWAP_ON_MAP::SWAP_SE != nil
        $game_player.animation_id = EUDY::SWAP_ON_MAP::SWAP_ANIM if EUDY::SWAP_ON_MAP::SWAP_ANIM != nil
        for i in 0...($game_party.members.size-1)
          loop do
            break if (Graphics.frame_count%EUDY::SWAP_ON_MAP::SWAP_DELAY==0)
            update
          end
          $game_party.swap_order(i,i+1)
        end
      elsif(EUDY::SWAP_ON_MAP::SWAP_MODE==2)
          $game_party.swap_order(0,1)
      end
    end
  end
  
end 