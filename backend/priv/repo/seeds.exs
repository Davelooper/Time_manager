alias Backend.{Repo, Accounts.User, Teams.Team, Clocks.Clock, WorkingTimes.WorkingTime}

# IMPORTANT  ! ! !
# IMPORTANT  ! ! !

#LE MOT DE PASSE POUR CHAQUE USER :
# ===> admin12345 <===

# IMPORTANT  ! ! !
# IMPORTANT  ! ! !



# Création des équipes
teams = [
  %Team{username: "Batman"},
  %Team{username: "Robin"},
  %Team{username: "Batgirl"},
  %Team{username: "Nightwing"},
  %Team{username: "The_Joker_Gang"},
  %Team{username: "Gotham_Police_Department"},
  %Team{username: "Harley_Quinn_Crew"},
  %Team{username: "The_Court_of_Owls"},
  %Team{username: "Justice_League"},
  %Team{username: "The_Bat_Family"},
  %Team{username: "Suicide_Squad"}
]

Enum.each(teams, fn team ->
  team = Repo.insert!(team)  # Insérer l'équipe

  # Créer les utilisateurs pour l'équipe
  users = [
    %User{email: "admin_#{team.username}@admin.com", username: "admin_user_#{team.username}", hashed_password: "$2b$12$xfFTpjwydEWhVsUEnMi5ZOx62GN77DRJksllYSLqt64mO7kSk8rXO", role: "admin", team_id: team.id},
    %User{email: "manager_#{team.username}@manager.com", username: "manager_user_#{team.username}", hashed_password: "$2b$12$xfFTpjwydEWhVsUEnMi5ZOx62GN77DRJksllYSLqt64mO7kSk8rXO", role: "manager", team_id: team.id},
    %User{email: "user1_#{team.username}@example.com", username: "simple_user1_#{team.username}", hashed_password: "$2b$12$xfFTpjwydEWhVsUEnMi5ZOx62GN77DRJksllYSLqt64mO7kSk8rXO", role: "user", team_id: team.id},
    %User{email: "user2_#{team.username}@example.com", username: "simple_user2_#{team.username}", hashed_password: "$2b$12$xfFTpjwydEWhVsUEnMi5ZOx62GN77DRJksllYSLqt64mO7kSk8rXO", role: "user", team_id: team.id},
    %User{email: "user3_#{team.username}@example.com", username: "simple_user3_#{team.username}", hashed_password: "$2b$12$xfFTpjwydEWhVsUEnMi5ZOx62GN77DRJksllYSLqt64mO7kSk8rXO", role: "user", team_id: team.id}
  ]

  Enum.each(users, fn user ->
    user = Repo.insert!(user)

    clocks = [
      # Pointages pour le 8 octobre 2024
      %Clock{time: ~U[2024-10-08 09:00:00Z], user_id: user.id},  # Pointage d'entrée
      %Clock{time: ~U[2024-10-08 17:00:00Z], user_id: user.id},  # Pointage de sortie

      # Pointages pour le 9 octobre 2024
      %Clock{time: ~U[2024-10-09 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-09 17:00:00Z], user_id: user.id},

      # Pointages pour le 10 octobre 2024
      %Clock{time: ~U[2024-10-10 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-10 17:00:00Z], user_id: user.id},

      # Pointages pour le 11 octobre 2024
      %Clock{time: ~U[2024-10-11 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-11 17:00:00Z], user_id: user.id},

      # Pointages pour le 12 octobre 2024
      %Clock{time: ~U[2024-10-12 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-12 17:00:00Z], user_id: user.id},

      # Pointages pour le 13 octobre 2024
      %Clock{time: ~U[2024-10-13 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-13 17:00:00Z], user_id: user.id},

      # Pointages pour le 14 octobre 2024
      %Clock{time: ~U[2024-10-14 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-14 17:00:00Z], user_id: user.id},

      # Pointages pour le 15 octobre 2024
      %Clock{time: ~U[2024-10-15 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-15 17:00:00Z], user_id: user.id},

      # Pointages pour le 16 octobre 2024
      %Clock{time: ~U[2024-10-16 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-16 17:00:00Z], user_id: user.id},

      # Pointages pour le 17 octobre 2024
      %Clock{time: ~U[2024-10-17 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-17 17:00:00Z], user_id: user.id},

      # Pointages pour le 18 octobre 2024
      %Clock{time: ~U[2024-10-18 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-18 17:00:00Z], user_id: user.id},

      # Pointages pour le 19 octobre 2024
      %Clock{time: ~U[2024-10-19 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-19 17:00:00Z], user_id: user.id},

      # Pointages pour le 20 octobre 2024
      %Clock{time: ~U[2024-10-20 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-20 17:00:00Z], user_id: user.id},

      # Pointages pour le 21 octobre 2024
      %Clock{time: ~U[2024-10-21 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-21 17:00:00Z], user_id: user.id},

      # Pointages pour le 22 octobre 2024
      %Clock{time: ~U[2024-10-22 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-22 17:00:00Z], user_id: user.id}
    ]


    # Insérer les Clocks
    Enum.each(clocks, fn clock ->
      Repo.insert!(clock)
    end)
  end)

    working_times = [
      %WorkingTime{
        start: ~U[2024-10-08 09:00:00Z],
        end: ~U[2024-10-08 17:00:00Z],
        team_id: team.id
      },
      %WorkingTime{
        start: ~U[2024-10-09 09:00:00Z],
        end: ~U[2024-10-09 17:00:00Z],
        team_id: team.id
      }
    ]

      Enum.each(working_times, fn working_time ->
        Repo.insert!(working_time)
      end)
end)
