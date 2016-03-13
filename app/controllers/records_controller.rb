class RecordsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        @records = Record.all
        @records = @records.sort_by(&:Date)
    end

    def search_get
    end

    def search_show
        # render plain: params[:Email].inspect
        @query =  params[:record][:Email]
        # render plain: @query.inspect
        @all = Record.all
        @all_answers = []

        for i in 0..(@all.length - 1)
            if (@all[i].user.email==@query)
                @all_answers = @all_answers + [@all[i]]
            end
        end

        # @allemails = ""
        # for i in 0..(@all_answers.length - 1)
        #     @allemails = @allemails << @all_answers[i].user.email
        # end
        # render plain: @allemails.inspect
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
            # temp_hash = params.require(:appointment).permit(:Date)
            params.require(:record).permit(:Prescriptions, :Symptoms, :Date)
        end
end
