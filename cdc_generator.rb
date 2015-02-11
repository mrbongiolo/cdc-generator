require 'rubygems'

SECTIONS = { 0 => "A", 1 => "B", 2 => "C", 3 => "D", 4 => "E" }

def rand_for(base_value, difference_percentage = 0.20)
   range_min = ( base_value - (base_value * difference_percentage) ).to_f
   range_max = ( base_value + (base_value * difference_percentage) ).to_f
   rand(range_min..range_max)
end

result = []

File.open('data.csv', 'r') do |f|
  f.each_line do |line|
    #columns are: UT, PIC, Num Arv, Nome, DAP, ALT, Obs./Cat.
    columns = line.split(';')

    dap = columns[4].gsub(',','.').to_f
    height = columns[5].to_i

    num_of_toras = case height
    when 0..12
      2
    when 13..22
      3
    else
      4
    end

    medium_height_of_toras = height / num_of_toras

    tdap = dap

    num_of_toras.times do |t|
      tora_height = rand_for(medium_height_of_toras).round(1)

      tora_dap_foot_one = (rand_for(tdap, 0.03).round(2) * 100 / 1).to_i
      tora_dap_foot_two = (rand_for(tdap, 0.03).round(2) * 100 / 1).to_i
      
      tdap = tdap - (tdap * 0.07)

      tora_dap_head_one = (rand_for(tdap, 0.03).round(2) * 100 / 1).to_i
      tora_dap_head_two = (rand_for(tdap, 0.03).round(2) * 100 / 1).to_i
      
      #final columns to export are: UT, ESP, N.Tora, ESPECIE, SECAO, ARV, PIC, COM, Pe1, Pe2, Pnt1, Pnt2
      tora = "#{columns[0]};ESP;N.TORA;#{columns[3]};#{SECTIONS[t]};#{columns[2]};#{columns[1]};#{tora_height.to_s.gsub('.',',')};#{tora_dap_foot_one};#{tora_dap_foot_two};#{tora_dap_head_one};#{tora_dap_head_two}"

      result << tora      
    end
  end
end

File.write('cdc.csv', result.join("\r"))
