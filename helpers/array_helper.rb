class Array
  def satan_shuffle #fisher-yates shuffle that will come out the same each time
    srand(666)
    shuffled_array = self.clone
    self.each_index do |original_index|
      new_index = rand original_index
      shuffled_array.swap! original_index, new_index
    end 
    shuffled_array
  end

  def swap!(original, new)
    tmp = self[original]
    self[original] = self[new]
    self[new] = tmp
  end
  
end
