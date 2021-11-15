-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/10 16:29:53                                                                                           
-------------------------------------------------------

---@class audio
local audio = class("audio");

local _musicAudioSource = nil;
local _soundAudioSources = {}

function audio.init()
    _musicAudioSource = GameGo:AddComponent(typeof(AudioSource));

    audio.PlayMusic("lobbyBG",true,0.3);
    audio.switchMusic();
end

function audio.switchMusic()
    if not data._musicEnable then
        audio.PauseMusic()
    else
        audio.RecoverMusic()
    end
end

local function AudioSourceCommon(audioSource, audioName, isLoop, volume, isPlayOneShot)
    audioSource.loop = isLoop;
    audioSource.volume = volume;
    audioSource.clip = AF:LoadAudioClip(audioName);

    if audioSource.enabled then
        if isPlayOneShot then
            audioSource:PlayOneShot(audioSource.clip);
        else
            audioSource:Play();
        end
    end
end

function audio.PlaySound(audioName, isLoop, volume, isPlayOneShot)
    if not data._soundEnable then
        do
            return
        end ;
    end

    local isLoop = isLoop or false;
    local volume = volume or 1;
    local isPlayOneShot = isPlayOneShot or false;

    if _soundAudioSources[audioName] ~= nil then
        if isPlayOneShot then
            _soundAudioSources[audioName]:PlayOneShot(audioSource.clip);
        else
            _soundAudioSources[audioName]:Play();
        end
    else
        local tempAudioSource = GameGo:AddComponent(typeof(AudioSource));
        _soundAudioSources[audioName] = tempAudioSource;
        AudioSourceCommon(tempAudioSource, audioName, isLoop, volume, isPlayOneShot);
    end

end

function audio.PlayMusic(audioName, isLoop, volume, isPlayOneShot)
    local isLoop = isLoop or false;
    local volume = volume or 1;
    local isPlayOneShot = isPlayOneShot or false;

    AudioSourceCommon(_musicAudioSource, audioName, isLoop, volume, isPlayOneShot);
end

function audio.PauseMusic()
    _musicAudioSource:Pause();
end

function audio.RecoverMusic()
    _musicAudioSource:UnPause();
end

return audio
