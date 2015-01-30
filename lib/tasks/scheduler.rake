desc "This task is called by the Heroku scheduler add-on"
task :delete_old_invitations => :environment do
  MatchInvitation.delete_old_invitations
end