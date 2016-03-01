class RecordsController < ApplicationController
    def index
        @records = Record.all
    end

    def new
    end

    def edit
        @record = Record.find(params[:id])
    end

    def update
        @record = Record.find(params[:id])
 
        if @record.update(movie_params)
            redirect_to @record
        else
            render 'edit'
        end
    end

    def show
        @record = Record.find(params[:id])
    end

    def create
        # render plain: params[:record].inspect
        @record = Record.new(movie_params)
        if @record.save
            redirect_to @record
        else
            render 'new'
        end
        # @record.save
        # redirect_to @record
    end

    def destroy
        @record = Record.find(params[:id])
        @record.destroy

        redirect_to records_path
    end

    private
        def movie_params
            params.require(:record).permit(:Prescriptions, :Symptoms, :Day, :Month, :Year)
        end
end
