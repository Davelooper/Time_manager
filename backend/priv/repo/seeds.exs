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
  %Team{username: "The Joker Gang"},
  %Team{username: "Gotham Police Department"},
  %Team{username: "Harley Quinn's Crew"},
  %Team{username: "The Court of Owls"},
  %Team{username: "Justice League"},
  %Team{username: "The Bat Family"},
  %Team{username: "Suicide Squad"}
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
      %Clock{time: ~U[2024-10-08 09:00:00Z], user_id: user.id},  # Pointage d'entrée
      %Clock{time: ~U[2024-10-08 17:00:00Z], user_id: user.id},  # Pointage de sortie
      %Clock{time: ~U[2024-10-09 09:00:00Z], user_id: user.id},
      %Clock{time: ~U[2024-10-09 17:00:00Z], user_id: user.id}
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
