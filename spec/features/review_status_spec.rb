require 'rails_helper'

feature "recenzje" do

  context "redaktor/recenzent, zgłoszenie, wersja w bazie danych" do
    before do
      Person.create!(name: "Andrzej", surname: "Kapusta", discipline: "filozofia", email: "a.kapusa@gmail.com", roles: ['redaktor', 'recenzent'])
      Submission.create!(person_id: Person.first, status: "odrzucony", polish_title: "Alicja w krainie czarów", english_title: "Alice 
        in Wonderland", polish_abstract: "Słów parę o tej bajce", english_abstract: "Little about that story", polish_keywords: "alicja",
        received: "19-01-2016", language: "polski")
      Article_revision.create!(submission_id: Submission.first, version: "1", received: "19-01-2016", pages: "5")  
    end
    
    context "2 recenzje w bazie danych" do
      before do
        Review.create!(article_revision_id: Article_revision.first, person_id: Person.first, status: "recenzja przyjęta", 
          asked: "18-01-2016", deadline: "03-03-2016" )
        Review.create!(article_revision_id: Article_revision.first, person_id: Person.first, status: "recenzja negatywna",
          asked: "11-11-2016", deadline: "24-04-2017")	
      end
  
      scenario "filtrowanie recenzji po statusie" do
        visit "/submissions"
    
        select "recenzja negatywna", from: "Status"
        click_on("Filtruj")
      
        expect(page).to have_content("24-04-2017")
        expect(page).not_to have_content("03-03-2016")
      end
    end
  end
end

