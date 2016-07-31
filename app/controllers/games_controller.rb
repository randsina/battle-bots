class GamesController < ApplicationController

  def create
    hash = params[:board][:cells].flatten.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    neighbours = set_neighbours(params[:board][:cells])
    hash.deep_merge!(neighbours) { |key, old_value, new_value| [old_value, new_value] }
    @map = Map.create(locations: hash, game_id: params[:id])
    render json: {status: :ok}
  end

  def show
    p params
    @map = Map.find_by(game_id: params[:id])
    p '#' * 200
    p 'Method show'
    p @map.id
    true_cell = nil
    sorted_locations = @map.locations.sort_by {|_key, value| -value[0]}
    sorted_locations.each do |cell|
      used_colors = cell[1][2].to_a
      p "cell - #{cell}"
      true_cell = cell[0]
      break if used_colors.exclude?(params[:color].to_i)
    end
    p "True cell - #{true_cell}"
    p '#' * 200
    render json: {
      status: :ok,
      figure: true_cell
    }
  end

  def update
    @map = Map.find_by(game_id: params[:id])
    figure = params[:figure]
    neighbours = @map.locations[figure][1]
    @map.locations[figure][0] = -1
    neighbours.map do |cell|
      @map.locations[cell][2] = (@map.locations[cell][2].to_a << params[:color]).uniq
    end
    @map.save
    render json: {status: :ok}
  end

  def destroy
    render json: {status: :ok}
  end

  private

  def set_neighbours(cells)
    cells.map! { |e| e.unshift(nil).push(nil) }.unshift(nil).push(nil)
    hash = Hash.new([])
    cells.each_with_index do |row, row_index|
      next if row.nil?
      row.each_with_index do |cell, col_index|
        next if cell.nil?
        neighbours = if row_index.odd?
          [
            cells[row_index - 1].try(:[],col_index),
            cells[row_index + 1].try(:[],col_index),
            cells[row_index].try(:[],col_index - 1),
            cells[row_index].try(:[],col_index + 1),
            cells[row_index - 1].try(:[],col_index - 1),
            cells[row_index - 1].try(:[],col_index + 1)
          ]
        else
          [
            cells[row_index - 1].try(:[],col_index),
            cells[row_index + 1].try(:[],col_index),
            cells[row_index].try(:[],col_index - 1),
            cells[row_index].try(:[],col_index + 1),
            cells[row_index + 1].try(:[],col_index - 1),
            cells[row_index + 1].try(:[],col_index + 1)
          ]
        end
        neighbours = neighbours.compact.uniq.to_a
        neighbours.delete(cell)
        hash[cell] = (hash[cell] + neighbours).uniq
      end
    end
    hash
  end

end
