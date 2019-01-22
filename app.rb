require 'bundler'
require 'open-uri'
require 'google_drive'

Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'scrapper.rb'

def save_as_json #                                        Prend le hash de la fonction get_townhall_email de la class Scrap
    tempHash = Scrap.new.get_townhall_email #             Et écrit chaque email du hash dans le fichier email.JSON 
    File.open("bd/emails.json","w") do |f|
        f.write(tempHash.to_json)
    end
end


def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("1Ar64MSajj1hHP6vps-TGmqUn1SsATqW0L6GTjtOAWIA").worksheets[0]
    n = 1
    tempHash = Scrap.new.get_townhall_email

    tempHash.each do |k,v|
    ws[n, 1] = k
    ws[n, 2] = v
    sleep(1.001)
    n += 1
    ws.save
    end

end

save_as_spreadsheet


def save_as_csv
    tempHash = Scrap.new.get_townhall_email
    CSV.open("bd/emails.csv", "wb") do |csv| 
        tempHash.to_a.each{|elem| csv << elem}
     end
end