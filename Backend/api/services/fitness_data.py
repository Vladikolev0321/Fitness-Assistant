from numpy import mean
from models import CaloriesStepsData, StravaActivities, WeightsData


def calculate_strava_activities_distance(curr_user):
    
    strava_activities = StravaActivities.query.filter_by(user_id=curr_user.id).all()
    rides = [act for act in strava_activities if act.type == 'Ride']
    runs = [act for act in strava_activities if act.type == 'Run']
    walks = [act for act in strava_activities if act.type == 'Walk']
    hikes = [act for act in strava_activities if act.type == 'Hike']
    
    ride_distance = int(sum(act.distance for act in rides)/1000)
    run_distance = int(sum(act.distance for act in runs)/1000)
    walk_distance = int(sum(act.distance for act in walks)/1000)
    hikes_distance = int(sum(act.distance for act in hikes)/1000)
    
    distances = {'ride_distance':ride_distance, 'run_distance':run_distance, 'walk_distance':walk_distance,
                    'hike_distance':hikes_distance}
    return distances

def calculate_strava_activities_distance_percentages(curr_user):

    distances = calculate_strava_activities_distance(curr_user)
    sum_distances = distances['ride_distance'] + distances['run_distance'] + distances['walk_distance'] + distances['hike_distance']
    percentages = {'ride_distance_percentage':percentage_from_whole(distances['ride_distance'], sum_distances),
                            'run_distance_percentage':percentage_from_whole(distances['run_distance'], sum_distances),
                            'walk_distance_percentage':percentage_from_whole(distances['walk_distance'], sum_distances),
                            'hike_distance_percentage':percentage_from_whole(distances['hike_distance'], sum_distances)}
    return percentages

def get_steps_for_last_7_days(curr_user):
    user_data = CaloriesStepsData.query.filter_by(user_id=curr_user.id).order_by(CaloriesStepsData.date)[-7:]
    steps = []
    for data in user_data:
        steps.append({'dateTime':data.date.strftime("%Y-%m-%d"), 'value':str(data.steps_count)})
    
    return steps

def get_average_steps_for_last_7_days(curr_user):
    steps = get_steps_for_last_7_days(curr_user)
    steps_average = mean([int(steps_act['value']) for steps_act in steps])

    return steps_average

def get_strava_activities_average_speeds_last_7_times(curr_user):
    strava_activities = StravaActivities.query.filter_by(user_id=curr_user.id).order_by(StravaActivities.date).all()
    rides = [act for act in strava_activities if act.type == 'Ride']
    runs = [act for act in strava_activities if act.type == 'Run']
    walks = [act for act in strava_activities if act.type == 'Walk']
    hikes = [act for act in strava_activities if act.type == 'Hike']

    rides_averages = [round((act.average_speed * 18) / 5, 2) for act in rides][-7:]
    runs_averages = [round((act.average_speed * 18) / 5, 2) for act in runs][-7:]
    walks_averages = [round((act.average_speed * 18) / 5, 2) for act in walks][-7:]
    hikes_averages= [round((act.average_speed * 18) / 5, 2) for act in hikes][-7:]
    
    return {'rides_averages':rides_averages,
            'runs_averages':runs_averages,
            'walks_averages':walks_averages,
            'hikes_averages':hikes_averages}

def get_strava_activities_average_speed_of_last_7_times(curr_user):
    average_speed_list = get_strava_activities_average_speeds_last_7_times(curr_user)
    return {'rides_average':mean(average_speed_list['rides_averages']),
            'runs_average':mean(average_speed_list['runs_averages']),
            'walks_average':mean(average_speed_list['walks_averages']),
            'hikes_average':mean(average_speed_list['hikes_averages'])}

def get_calories_last_7_days(curr_user):
    user_data = CaloriesStepsData.query.filter_by(user_id=curr_user.id).order_by(CaloriesStepsData.date)[-7:]
    calories_burned = []
    for data in user_data:
        calories_burned.append({'dateTime':data.date.strftime("%Y-%m-%d"), 'value':str(data.calories_out)})
    
    return calories_burned

def get_calories_average_last_7_days(curr_user):
    user_data = CaloriesStepsData.query.filter_by(user_id=curr_user.id).order_by(CaloriesStepsData.date)[-7:]
    calories_burned_average = mean([calories_info.calories_out for calories_info in user_data])
    return calories_burned_average

def get_logged_weight_last_10_times(curr_user):
    weights = WeightsData.query.filter_by(user_id=curr_user.id).order_by(WeightsData.date)[-10:]
    weights = [weight_info.weight * 0.453592 for weight_info in weights]
    return weights

def get_logged_weight_average_last_10_times(curr_user):
    weights = get_logged_weight_last_10_times(curr_user)
    return mean(weights)

def percentage_from_whole(part, whole):
        percentage = 100 * float(part)/float(whole)
        return percentage