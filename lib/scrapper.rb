class Scrap

@@page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
@@arr_mails = []
@@arr_final = []

    def get_townhall_urls
        @city = @@page.xpath('//a[@class="lientxt"]').collect{|ville| ville.text.downcase.gsub(" ", "_") }
        #=> Sort le nom des villes en downcase avec un "_"
    end


    def get_townhall_email
        @end_link = @@page.xpath('//a[@class="lientxt"]').collect{|x| x['href']}.each{|x| x.slice!(0)}
        #=> Sort la fin du lien de chaque ville ( en "/95/wy-dit-joli-village.html" )

        @link_city = @end_link.map{|p| "http://annuaire-des-mairies.com" + p}
        #=> Créé les liens des villes entiers
        
        @result_mail = @link_city.each{|link| @@arr_mails.push(Nokogiri::HTML(open(link)).css("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text)}
        #=> Trouve l'email de chaque ville et l'ajoute dans l'array @@arr_mails
        
        @hash = Hash[get_townhall_urls.zip(@@arr_mails)]
        #=> Créé un Hash avec les données de city et mails

        #@@arr_final << @hash
        #=> Envoie le hash dans l'array @@arr_final
    end

end
#binding.pry