class RecordsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        @records = Record.all
    end

    def new
        # @record = Record.new

        @record = current_user.records.build
    end

    def edit
        @record = Record.find(params[:id])
    end

    def update
        @record = Record.find(params[:id])
 
        if @record.update(records_params)
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

        @record = current_user.records.build(records_params)
        # @record = Record.new(records_params)
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
        def records_params
            params.require(:record).permit(:Prescriptions, :Symptoms, :Day, :Month, :Year)
        end
end
